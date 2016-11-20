defmodule DevNotex.Mutations.CreateUserTest do
  use DevNotex.ConnCase

  alias DevNotex.{User, Repo}

  @valid_attrs %{ email: "foo@bar.com", password: "foobar123" }

  setup do
    conn = build_conn()
           |> put_req_header("content-type", "application/graphql")
    {:ok, conn: conn}
  end

  @valid_query """
    mutation CreateUser {
      user(email: "foo@bar.com", password: "foobar123") {
        id
        email
      }
    }
  """

  describe "mutation CreateUser" do
    test "it creates user and returns him if attributes are valid", %{conn: conn} do
      conn = post(conn, "/api/guest", @valid_query)

      user = json_response(conn, 200)["data"]["user"]

      assert user
      assert user["email"] == @valid_attrs[:email]
      refute user["id"] == nil

      assert Repo.get(User, user["id"])
    end

    @tag :skip
    test "it rejects duplicated user email for signup" do
      User.registration_changeset(%User{}, @valid_attrs) |> Repo.insert

      conn = post(conn, "/api/guest", @valid_query)

      user = json_response(conn, 422)["data"]["user"]

      assert user
      assert user["email"] == @valid_attrs[:email]
      assert user["id"] == nil
      refute user["emails"] == nil
    end

    @tag :skip
    test "it reject user signup with invalid email" do
    end

    @tag :skip
    test "it reject user singup with invalid password" do
    end

    @tag :skip
    test "it rejects user signup with invalid password and email" do
    end
  end
end
