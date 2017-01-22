defmodule DevNotex.AuthenticationTokenTest do
  use DevNotex.ModelCase, async: true

  alias DevNotex.AuthenticationToken

  @valid_attrs %{user_id: 1}
  @invalid_attrs %{}

  test "create_changeset with valid attributes" do
    changeset = AuthenticationToken.create_changeset(%AuthenticationToken{}, @valid_attrs)
    assert changeset.valid?
  end

  test "create_changeset with invalid attributes" do
    changeset = AuthenticationToken.create_changeset(%AuthenticationToken{}, @invalid_attrs)
    refute changeset.valid?
  end
end
