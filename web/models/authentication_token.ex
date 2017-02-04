defmodule DevNotex.AuthenticationToken do
  use DevNotex.Web, :model

  schema "authentication_tokens" do
    belongs_to :user, DevNotex.User

    field :token, :string

    timestamps()
  end

  @required_fields ~w(user_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def create_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> put_change(:token, SecureRandom.urlsafe_base64())
  end
end
