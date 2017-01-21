defmodule DevNotex.Repo.Migrations.CreateNote do
  use Ecto.Migration

  def change do
    create table(:notes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:notes, [:user_id])
  end
end
