defmodule DevNotex.UserTest do
  use DevNotex.ModelCase

  alias DevNotex.User

  @valid_attrs %{email: "foo@bar.com", password: "somecontent"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
