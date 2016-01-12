defmodule Cazoc.Repo.Migrations.CreateCollaborator do
  use Ecto.Migration

  def change do
    create table(:collaborators) do
      add :family_id, references(:families, on_delete: :nothing)
      add :author_id, references(:authors, on_delete: :nothing)

      timestamps
    end
    create index(:collaborators, [:family_id])
    create index(:collaborators, [:author_id])

  end
end
