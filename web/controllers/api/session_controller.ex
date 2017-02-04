defmodule DevNotex.Api.SessionController do
  use DevNotex.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias DevNotex.AuthenticationToken, as: Token
  alias DevNotex.User

  def create(conn, %{ "user" => user_params }) do
    user = Repo.get_by(User, email: user_params["email"])

    cond do
      user && checkpw(user_params["password"], user.crypted_password) ->
        token_changeset = Token.create_changeset(%Token{}, %{user_id: user.id})
        {:ok, token} = Repo.insert(token_changeset)
        conn
        |> put_status(:created)
        |> render("create.json", token: token)
      user ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json")
      true ->
        dummy_checkpw

        conn
        |> put_status(:unauthorized)
        |> render("error.json")
    end
  end

  def delete(conn, _params) do
    token = conn.assigns[:current_token]

    Repo.delete(token)

    render conn, "delete.json"
  end
end
