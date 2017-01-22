defmodule DevNotex.Api.NoteControllerTest do
  use DevNotex.ConnCase

  alias DevNotex.{User, AuthenticationToken, Repo}

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
    setup [:authenticate_user, :create_note, :get_notes]

    test " lists all notes", %{conn: conn} do
      resp = json_response(conn, 200)

      data = resp["data"]

      assert data

      assert Enum.count(data) == 2
    end
  end

  defp authenticate_user(_context) do
    {:ok, user} = %User{}
                  |> User.registration_changeset(%{ email: "foo@bar.com", password: "foobar", password_confirmation: "foobar"})
                  |> Repo.insert

    {:ok, token} = %AuthenticationToken{}
                   |> AuthenticationToken.create_changeset(%{user_id: user.id})
                   |> Repo.insert


    conn = build_conn
           |> put_req_header("authorization", "Bearer #{token.token}")

    %{ conn: conn, user: user, token: token }
  end

  defp create_note(context) do
    user = context[:user]

    {:ok, note} = Ecto.build_assoc(user, :notes, %{ title: "Title", content: "Long content"})
                  |> Repo.insert

    {:ok, _note2} = Ecto.build_assoc(user, :notes, %{ title: "Title 2", content: "Long content"})
                    |> Repo.insert

    %{ note: note }
  end

  defp get_notes(context) do
    conn = context[:conn]
    conn = conn |> get(note_path(conn, :index))

    %{ conn: conn }
  end
end
