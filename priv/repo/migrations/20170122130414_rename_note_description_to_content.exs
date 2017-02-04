defmodule DevNotex.Repo.Migrations.RenameNoteDescriptionToContent do
  use Ecto.Migration

  def change do
    rename table(:notes), :description, to: :content
  end
end
