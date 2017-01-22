defmodule DevNotex.Api.NoteControllerTest do
  use DevNotex.ConnCase

  import DevNotex.Factory

  alias DevNotex.{Note, Repo}

  @valid_attrs %{ title: "My test note" }

  describe "when user is not authenticated" do
    test "rejects all requests" do
      conn = build_conn
      Enum.each([
        get(conn, note_path(conn, :index)),
        get(conn, note_path(conn, :show, "1")),
        post(conn, note_path(conn, :create)),
        put(conn, note_path(conn, :update, "1")),
        delete(conn, note_path(conn, :delete, "1"))
      ], fn conn ->
        assert json_response(conn, 401)
        assert conn.halted
      end)
    end
  end

  describe "when user is authenticated | GET /notes" do
    setup [:authenticate_user, :create_notes, :get_notes]

    test "user has all created notes", %{notes: notes} do
      assert Enum.count(notes) == 2
    end

    test "lists all notes", %{conn: conn, notes: notes} do
      resp = json_response(conn, 200)

      data = resp["data"]

      assert data

      assert Enum.count(data) == Enum.count(notes)
    end


    test "does not list notes from other user", %{conn: conn, notes: notes} do
      insert(:user, email: "bar@diff.com") |> with_note

      resp = json_response(conn, 200)

      data = resp["data"]

      assert Enum.count(data) == Enum.count(notes)
      assert Note |> Repo.aggregate(:count, :id) == Enum.count(notes) + 1
    end

    test "note in list has all expected attributes", %{conn: conn, notes: notes} do
      resp = json_response(conn, 200)

      {:ok, tested_note} = Enum.fetch(notes, 0)
      {:ok, resp_note} = Enum.fetch(resp["data"], 0)

      assert resp_note["attributes"]["title"] == tested_note.title
      assert resp_note["attributes"]["content"] == tested_note.content
      assert resp_note["id"] == tested_note.id
    end
  end

  describe "when user is authenticated | GET /note/{id}" do
    setup [:authenticate_user, :create_note]

    test "it returns note with expected attributes if note exists", %{conn: conn, note: tested_note} do
      conn = conn |> get(note_path(conn, :show, tested_note.id))

      resp = json_response(conn, 200)
      resp_note = resp["data"]

      assert resp_note["attributes"]["title"] == tested_note.title
      assert resp_note["attributes"]["content"] == tested_note.content
      assert resp_note["id"] == tested_note.id
    end

    test "it returns not found if note exists for another user", %{conn: conn } do
      other_note = insert(:user, email: "bar@diff.com")
                   |> with_note
                   |> assoc(:notes)
                   |> Repo.one

      assert_error_sent 404, fn ->
        conn |> get(note_path(conn, :show, other_note.id))
      end
    end

    test "it returns not found if note does not exist", %{conn: conn } do
      assert_error_sent 404, fn ->
        conn |> get(note_path(conn, :show, Ecto.UUID.generate))
      end
    end
  end

  defp authenticate_user(_context) do
    user = insert(:user) |> with_token

    token = user |> assoc(:authentication_tokens) |> Repo.one

    conn = build_conn
           |> put_req_header("authorization", "Bearer #{token.token}")

    %{ conn: conn, user: user, token: token }
  end

  defp create_notes(context) do
    user = context[:user]

    user |> with_note |> with_note

    notes = user |> assoc(:notes) |> Repo.all

    %{ notes: notes }
  end

  defp create_note(context) do
    user = context[:user]

    note = user |> with_note |> assoc(:notes) |> Repo.one

    %{ note: note }
  end

  defp get_notes(context) do
    conn = context[:conn]
    conn = conn |> get(note_path(conn, :index))

    %{ conn: conn }
  end
end
