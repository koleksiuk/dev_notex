defmodule DevNotex.User do
  use DevNotex.Web, :model

  schema "users" do
    has_many :authentication_tokens, DevNotex.AuthenticationToken

    field :email, :string
    field :password, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
  end
end
