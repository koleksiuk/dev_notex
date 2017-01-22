defmodule DevNotex.Api.NoteController do
  use DevNotex.Web, :controller

  plug :scrub_params, "data" when action in [:create, :update]

  alias DevNotex.{Note}

  def index(conn, params, current_user) do
    notes = current_user |> user_notes |> Repo.all

    conn
    |> render("index.json", %{ notes: notes, conn: conn, params: params })
  end

  def show(conn, params = %{"id" => id}, current_user) do
    note = current_user |> user_notes |> Repo.get!(id)

    conn
    |> render("show.json", %{ note: note, conn: conn, params: params })
  end

  def action(conn, _) do
    apply(
      __MODULE__,
      action_name(conn),
      [conn, conn.params, conn.assigns.current_user]
    )
  end

  defp user_notes(user) do
    assoc(user, :notes)
  end
end
