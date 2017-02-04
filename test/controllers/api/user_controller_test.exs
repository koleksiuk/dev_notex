defmodule DevNotex.Api.UserControllerTest do
  use DevNotex.ConnCase

  alias DevNotex.{User, Repo}

  @valid_attrs %{
    email: "foo@bar.com",
    password: "foobar123",
    password_conmtion: "foobar123"
  }

  setup do
    {:ok, conn: put_req_header(build_conn, "accept", "application/json")}
  end

  describe "POST /api/users" do
    test "it creates user and returns it if attributes are valid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: @valid_attrs)

      data = json_response(conn, 201)["data"]

      attributes = data["attributes"]

      assert attributes
      assert attributes["email"] == "foo@bar.com"
      assert Repo.get_by(User, id: data["id"])
    end

    test "does not create user if it already exists", %{conn: conn} do
      user_changeset = User.registration_changeset(%User{}, @valid_attrs)
      Repo.insert(user_changeset)

      conn = post(conn, user_path(conn, :create), user: @valid_attrs)

      errors= json_response(conn, 422)["errors"]

      assert errors

      %{"source" => %{"pointer" => attribute}} = Enum.at(errors, 0)

      assert attribute =="/data/attributes/email"
    end
  end
end
