defmodule DevNotex.Repo.Migrations.CreateAuthenticationToken do
  use Ecto.Migration

  def change do
    create table(:authentication_tokens) do
      add :token, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:authentication_tokens, [:user_id])

  end
end
