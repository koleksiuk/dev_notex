defmodule DevNotex.Api.NoteControllerTest do
  use DevNotex.ConnCase

  import DevNotex.Factory

  alias DevNotex.{Note, Repo}

  @valid_params %{"data" => %{"title" => "My note", "content" => "Long Content" } }
  @invalid_params %{"data" => %{"title" => "", "content" => "Long content" }}

  describe "when user is not authenticated" do
    test "rejects all requests" do
      conn = build_conn
      Enum.each([
        get(conn, note_path(conn, :index)),
        get(conn, note_path(conn, :show, "1")),
        post(conn, note_path(conn, :create, @valid_params)),
        put(conn, note_path(conn, :update, "1", @valid_params)),
        delete(conn, note_path(conn, :delete, "1", @valid_params))
      ], fn conn ->
        assert json_response(conn, 401)
        assert conn.halted
      end)
    end
  end

  describe "when user is authenticated | GET /api/notes" do
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

  describe "when user is authenticated | GET /api/notes/{id}" do
    setup [:authenticate_user, :create_note]

    test "it returns note with expected attributes if note exists", %{conn: conn, note: tested_note} do
      conn = conn |> get(note_path(conn, :show, tested_note.id))

      resp = json_response(conn, 200)
      resp_note = resp["data"]

      assert resp_note["attributes"]["title"] == tested_note.title
      assert resp_note["attributes"]["content"] == tested_note.content
      assert resp_note["id"] == tested_note.id
    end

    test "it returns not found if note exists for another user", %{conn: conn} do
      other_note = insert(:user, email: "bar@diff.com")
                   |> with_note
                   |> assoc(:notes)
                   |> Repo.one

      assert_error_sent 404, fn ->
        conn |> get(note_path(conn, :show, other_note.id))
      end
    end

    test "it returns not found if note does not exist", %{conn: conn} do
      assert_error_sent 404, fn ->
        conn |> get(note_path(conn, :show, Ecto.UUID.generate))
      end
    end
  end

  describe "when user is authenticated | POST /api/notes" do
    setup [:authenticate_user]

    test "it creates a note for given user when attributes are valid", %{conn: conn, user: user} do
      conn |> post(note_path(conn, :create, @valid_params))

      note = user |> Ecto.assoc(:notes) |> Repo.one

      assert note.title == @valid_params["data"]["title"]
      assert note.content == @valid_params["data"]["content"]

      assert user |> Ecto.assoc(:notes) |> Repo.aggregate(:count, :id) == 1
    end

    test "it returns note in a response when attributes are valid", %{conn: conn} do
      conn = conn |> post(note_path(conn, :create, @valid_params))

      resp = json_response(conn, 201)

      resp_note = resp["data"]

      assert resp_note["attributes"]["title"] == "My note"
      assert resp_note["attributes"]["content"] == "Long Content"
      assert resp_note["id"]
    end

    test "it returns error when attributes are invalid", %{conn: conn} do
      conn = conn |> post(note_path(conn, :create, @invalid_params))

      errors = json_response(conn, 422)["errors"]

      assert errors

      %{"source" => %{"pointer" => attribute}} = Enum.at(errors, 0)

      assert attribute =="/data/attributes/title"
    end
  end

  describe "when user is authenticated | PUT /api/notes/{id}" do
    setup [:authenticate_user, :create_note]

    test "it updates a note for given user when attributes are valid", %{conn: conn, note: note} do
      conn |> put(note_path(conn, :update, note.id, @valid_params))

      updated_note = Repo.get!(Note, note.id)

      assert updated_note.title == @valid_params["data"]["title"]
      assert updated_note.content == @valid_params["data"]["content"]
    end

    test "it returns note in a response when attributes are valid", %{conn: conn, note: note} do
      conn = conn |> put(note_path(conn, :update, note.id, @valid_params))

      resp = json_response(conn, 200)

      resp_note = resp["data"]

      assert resp_note["attributes"]["title"] == "My note"
      assert resp_note["attributes"]["content"] == "Long Content"
      assert resp_note["id"]
      assert Repo.get(Note, resp_note["id"])
    end

    test "it updates a note for when some attributes are given", %{conn: conn, note: note} do
      params = %{"data" => %{"content" => "New content"}}
      conn |> put(note_path(conn, :update, note.id, params))

      updated_note = Repo.get!(Note, note.id)

      assert updated_note.title == note.title
      assert updated_note.content == "New content"
    end

    test "it returns error when attributes are invalid", %{conn: conn, note: note} do
      conn = conn |> put(note_path(conn, :update, note.id, @invalid_params))

      errors = json_response(conn, 422)["errors"]

      assert errors

      %{"source" => %{"pointer" => attribute}} = Enum.at(errors, 0)

      assert attribute =="/data/attributes/title"
    end

    test "it returns not found if note exists for another user", %{conn: conn} do
      other_note = insert(:user, email: "bar@diff.com")
                   |> with_note
                   |> assoc(:notes)
                   |> Repo.one

      assert_error_sent 404, fn ->
        conn |> put(note_path(conn, :update, other_note.id, @valid_params))
      end
    end

    test "it returns not found if note does not exist", %{conn: conn} do
      assert_error_sent 404, fn ->
        conn |> put(note_path(conn, :update, Ecto.UUID.generate, @valid_params))
      end
    end
  end

  describe "when user is authenticated | DELETE /api/notes/{id}" do
    setup [:authenticate_user, :create_note]

    test "it deletes a note", %{conn: conn, note: note} do
      conn |> delete(note_path(conn, :delete, note.id))

      assert Repo.get(Note, note.id) == nil
    end

    test "returns empty response", %{conn: conn, note: note} do
      conn = conn |> delete(note_path(conn, :delete, note.id))

      resp = response(conn, 204)
      assert resp == ""
    end

    test "it returns not found if note exists for another user", %{conn: conn} do
      other_note = insert(:user, email: "bar@diff.com")
                   |> with_note
                   |> assoc(:notes)
                   |> Repo.one

      assert_error_sent 404, fn ->
        conn |> delete(note_path(conn, :delete, other_note.id))
      end
    end

    test "it returns not found if note does not exist", %{conn: conn} do
      assert_error_sent 404, fn ->
        conn |> delete(note_path(conn, :delete, Ecto.UUID.generate))
      end
    end
  end

  defp authenticate_user(_context) do
    user = insert(:user) |> with_token

    token = user |> assoc(:authentication_tokens) |> Repo.one

    conn = build_conn
           |> put_req_header("authorization", "Bearer #{token.token}")

    %{conn: conn, user: user, token: token }
  end

  defp create_notes(context) do
    user = context[:user]

    user |> with_note |> with_note

    notes = user |> assoc(:notes) |> Repo.all

    %{notes: notes }
  end

  defp create_note(context) do
    user = context[:user]

    note = user |> with_note |> assoc(:notes) |> Repo.one

    %{note: note }
  end

  defp get_notes(context) do
    conn = context[:conn]
    conn = conn |> get(note_path(conn, :index))

    %{conn: conn}
  end
end
