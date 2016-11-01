defmodule DevNotex.SessionsControllerTest do
  use DevNotex.ConnCase

  alias DevNotex.{User, AuthenticationToken, Repo}

  @valid_attrs %{ email: "foo@bar.com", password: "foobar123" }

  setup do
    changeset = User.registration_changeset(%User{}, @valid_attrs)
    Repo.insert(changeset)

    {:ok, conn: put_req_header(build_conn, "accept", "application/json")}
  end

  describe "POST /api/session" do
    test "it creates token and returns it if credentials are valid", %{conn: conn} do
      conn = post(conn, session_path(conn, :create), user: @valid_attrs)

      token = json_response(conn, 201)["data"]["token"]

      assert token
      assert Repo.get_by(AuthenticationToken, token: token)
    end

    test "it retuns error and does not create token if email is invalid", %{conn: conn} do
      conn = post(conn, session_path(conn, :create), user: Map.put(@valid_attrs, :email, "bar@foo.com"))

      assert json_response(conn, 401)["errors"] != %{}
    end

    test "it retuns error and does not create token if password is invalid", %{conn: conn} do
      conn = post(conn, session_path(conn, :create), user: Map.put(@valid_attrs, :password, "invalid"))

      assert json_response(conn, 401)["errors"] != %{}
    end
  end
end
