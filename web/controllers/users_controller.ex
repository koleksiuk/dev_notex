defmodule DevNotex.UsersController do
  use DevNotex.Web, :controller

  alias DevNotex.User

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    {state, changeset} = DevNotex.Registration.create(changeset, DevNotex.Repo)

    render(conn, "create.json", %{ user: changeset })
  end
end
