defmodule DevNotex.AuthenticationToken do
  use DevNotex.Web, :model

  schema "authentication_tokens" do
    belongs_to :user, DevNotex.User

    field :token, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:token])
    |> validate_required([:token])
  end
end
