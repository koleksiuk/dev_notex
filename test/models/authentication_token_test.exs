defmodule DevNotex.AuthenticationTokenTest do
  use DevNotex.ModelCase

  alias DevNotex.AuthenticationToken

  @valid_attrs %{token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AuthenticationToken.changeset(%AuthenticationToken{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AuthenticationToken.changeset(%AuthenticationToken{}, @invalid_attrs)
    refute changeset.valid?
  end
end
