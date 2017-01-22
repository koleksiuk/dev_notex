defmodule DevNotex.Note do
  use DevNotex.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "notes" do
    field :title, :string
    field :content, :string
    belongs_to :user, DevNotex.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content])
    |> validate_required([:title])
  end
end
