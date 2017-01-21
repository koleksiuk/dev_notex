defmodule DevNotex.Note do
  use DevNotex.Web, :model

  schema "notes" do
    field :title, :string
    field :description, :string
    belongs_to :user, DevNotex.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description])
    |> validate_required([:title])
  end
end
