defmodule DevNotex.Authentication.TokenPlug do
  import Plug.Conn

  @behaviour Plug

  @moduledoc """
  Plug that protects routes from unauthenticated access.
  If a header with name "authorization" and value "Bearer \#{token}"
  is present, and "token" can be decoded with the applications token secret,
  the user is authenticated and the decoded token is assigned to the connection
  under the key "authenticated_user".
  """

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    case check_token(get_req_header(conn, "authorization"), repo) do
      {:ok, user} -> assign(conn, :current_user, user)
      {:error, message} -> send_resp(conn, 401, Poison.encode!(%{error: message})) |> halt
    end
  end

  defp check_token([token], repo) do
    case user_for_token(String.split(token), repo) do
      {:ok, user }     -> {:ok, user}
      {:error, reason} -> {:error, reason}
    end
  end

  defp user_for_token(["Bearer", token], repo) do
    case get_token_with_user(repo, token) do
      nil        -> {:error, "invalid token"}
      auth_token ->
        auth_token = auth_token |> repo.preload([:user])
        {:ok, auth_token.user}
    end
  end

  defp user_for_token(_, _repo) do
    {:error, "invalid format of authorization"}
  end

  defp get_token_with_user(repo, token) do
    DevNotex.AuthenticationToken
    |> repo.get_by(token: token)
  end
end
