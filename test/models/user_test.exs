defmodule DevNotex.UserTest do
  use DevNotex.ModelCase, async: true

  alias DevNotex.User

  @valid_attrs %{
    email: "foo@bar.com",
    password: "foobar",
    password_confirmation: "foobar"
  }

  describe "registration_changeset" do
    test "changeset with valid attributes" do
      changeset = User.registration_changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid email" do
      attrs = Map.put(@valid_attrs, :email, "foo")
      changeset = User.registration_changeset(%User{}, attrs)
      refute changeset.valid?
    end

    test "changeset with invalid password" do
      attrs = Map.put(@valid_attrs, :password, "t")
      changeset = User.registration_changeset(%User{}, attrs)
      refute changeset.valid?
    end
  end
end
