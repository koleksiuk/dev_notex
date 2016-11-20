defmodule DevNotex.UserResolver do
  use DevNotex.Web, :resolver

  alias DevNotex.User

  def create(args, _info) do
    user_changeset = User.registration_changeset(%User{}, args)

    case Repo.insert(user_changeset) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
