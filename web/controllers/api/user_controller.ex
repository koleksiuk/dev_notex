defmodule DevNotex.Api.UserController do
  use DevNotex.Web, :controller

  alias DevNotex.User

  def create(conn, params = %{ "user" => user_params }) do
    user_changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(user_changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", %{user: user, conn: conn, params: params})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DevNotex.Api.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
