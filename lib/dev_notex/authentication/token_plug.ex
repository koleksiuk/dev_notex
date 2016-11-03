defmodule DevNotex.Authentication.TokenPlug do
  import Plug.Conn

  @behaviour Plug

  @moduledoc """
  Plug that protects routes from unauthenticated access.
  If a header with name "authorization" and value "Bearer \#{token}"
  is present, and "token" can be found in database, it is used to assign
  current_user and current_token,
  """

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    case check_token(get_req_header(conn, "authorization"), repo) do
      {:ok, auth_token} ->
        conn
        |> assign(:current_user, auth_token.user)
        |> assign(:current_token, auth_token)
      {:error, message} ->
        conn
        |> send_resp(401, Poison.encode!(%{error: message}))
        |> halt
    end
  end

  defp check_token([token], repo) do
    case get_token(String.split(token), repo) do
      {:ok, auth_token} -> {:ok, auth_token}
      {:error, reason}  -> {:error, reason}
    end
  end

  defp get_token(["Bearer", token], repo) do
    case get_token_with_user(repo, token) do
      nil        -> {:error, "invalid token"}
      auth_token ->
        auth_token = repo.preload(auth_token, [:user])
        {:ok, auth_token}
    end
  end

  defp get_token(_, _repo) do
    {:error, "invalid format of authorization"}
  end

  defp get_token_with_user(repo, token) do
    DevNotex.AuthenticationToken
    |> repo.get_by(token: token)
  end
end
