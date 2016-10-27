defmodule DevNotex.UsersController do
  use DevNotex.Web, :controller

  alias DevNotex.User

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case DevNotex.Registration.create(changeset, DevNotex.Repo) do
      {:ok, user} -> render(conn, "create.json", %{ user: user })
      {:error, changeset} -> render(conn, "create_error.json", %{ changeset: changeset })
    end
  end
end
