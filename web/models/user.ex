defmodule DevNotex.User do
  use DevNotex.Web, :model

  schema "users" do
    has_many :authentication_tokens, DevNotex.AuthenticationToken

    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email, min: 6, max: 255)
  end

  @doc """
  Builds a registration changeset based on the `struct` and `params`.
  """
  def registration_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 5)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :crypted_password, hashed_password(pass))
      _ ->
        changeset
    end
  end

  def hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end
