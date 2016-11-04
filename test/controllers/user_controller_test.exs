defmodule DevNotex.UserControllerTest do
  use DevNotex.ConnCase

  alias DevNotex.{User, Repo}

  @valid_attrs %{ email: "foo@bar.com", password: "foobar123" }

  setup do
    {:ok, conn: build_conn()}
  end

  describe "POST /api/users" do
    test "it creates user and returns him if attributes are valid", %{conn: conn} do
      conn = post(conn,
                  user_path(conn, :create),
                  user: @valid_attrs)

      user = json_response(conn, 201)["data"]["user"]

      assert user
      assert user["email"] == @valid_attrs[:email]

      assert Repo.get(User, user["id"])
    end

    test "it rejects duplicated user email for signup", %{conn: conn} do
      User.registration_changeset(%User{}, @valid_attrs) |> Repo.insert

      conn = post(conn,
                  user_path(conn, :create),
                  user: @valid_attrs)

      data = json_response(conn, 422)
      %{ "data" => %{ "user" => user }, "errors" => errors } = data

      assert user
      assert user["id"] == nil
      assert user["email"] == @valid_attrs[:email]
      [%{ "field" => field }] = errors
      assert field == "email"
    end

    test "it reject user signup with invalid email", %{conn: conn} do
      conn = post(conn,
                  user_path(conn, :create),
                  user: Map.put(@valid_attrs, :email, "@foo.com"))

      data = json_response(conn, 422)
      %{ "data" => %{ "user" => user }, "errors" => errors } = data

      assert user
      assert user["id"] == nil
      assert user["email"] == "@foo.com"
      [%{ "field" => field }] = errors
      assert field == "email"
    end

    test "it reject user singup with invalid password", %{conn: conn} do
      conn = post(conn,
                  user_path(conn, :create),
                  user: Map.put(@valid_attrs, :password, "foo"))

      data = json_response(conn, 422)
      %{ "data" => %{ "user" => user }, "errors" => errors } = data


      assert user
      assert user["id"] == nil
      assert user["email"] == @valid_attrs[:email]
      [%{ "field" => field }] = errors
      assert field == "password"
    end

    test "it rejects user signup with invalid password and email", %{conn: conn} do
      conn = post(conn,
                  user_path(conn, :create),
                  user: %{})

      data = json_response(conn, 422)
      %{ "data" => %{ "user" => user }, "errors" => errors } = data


      assert user
      assert user["id"] == nil
      assert user["email"] == nil
      assert ["email", "password"] == Enum.map(errors, &(&1["field"])) |> Enum.sort
    end
  end
end
