defmodule DevNotex.UsersController do
  use DevNotex.Web, :controller

  alias DevNotex.User

  def create(conn, %{"user" => user_params}) do
    user_changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(user_changeset) do
      {:ok, user} -> render(conn, "create.json", %{ user: user })
      {:error, changeset} -> render(conn, "create_error.json", %{ changeset: changeset })
    end
  end
end
