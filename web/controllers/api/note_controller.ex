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

  def create(conn, %{ "data" => params }, current_user) do
    note_changeset = Note.create_changeset(%Note{}, params)
                     |> Ecto.Changeset.put_assoc(:user, current_user)

    case Repo.insert(note_changeset) do
      {:ok, note} ->
        conn
        |> put_status(:created)
        |> render("show.json", %{ note: note, conn: conn, params: params })
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DevNotex.Api.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "data" => params}, current_user) do
    note = current_user |> user_notes |> Repo.get!(id)

    note_changeset = Note.update_changeset(note, params)

    case Repo.update(note_changeset) do
      {:ok, note} ->
        conn
        |> put_status(:ok)
        |> render("show.json", %{ note: note, conn: conn, params: params })
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DevNotex.Api.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    note = current_user |> user_notes |> Repo.get!(id)

    Repo.delete(note)

    conn
    |> send_resp(:no_content, "")
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
