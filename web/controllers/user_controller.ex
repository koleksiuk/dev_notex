defmodule DevNotex.UserController do
  use DevNotex.Web, :controller

  alias DevNotex.User

  def create(conn, %{"user" => user_params}) do
    user_changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(user_changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("create.json", %{ user: user })
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("create_error.json", %{ changeset: changeset })
    end
  end
end
