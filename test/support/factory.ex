defmodule DevNotex.Factory do
  use ExMachina.Ecto, repo: DevNotex.Repo

  alias DevNotex.{AuthenticationToken, Note, User}

  def user_factory do
    %User {
      email: "foo@bar.com"
    }
  end

  def authentication_token_factory do
    %AuthenticationToken {}
    |> AuthenticationToken.create_changeset(%{})
    |> Ecto.Changeset.apply_changes()
  end

  def note_factory do
    %Note {
      title: "Note title",
      content: "Very long content",
      user: build(:user)
    }
  end

  def with_token(user) do
    insert(:authentication_token, user: user)
    user
  end

  def with_note(user) do
    insert(:note, user: user)
    user
  end
end
