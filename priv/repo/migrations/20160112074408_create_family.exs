defmodule Cazoc.Repo.Migrations.CreateFamily do
  use Ecto.Migration

  def change do
    create table(:families) do
      add :name, :string
      add :display_name, :string
      add :description, :string
      add :cover, :string
      add :author_id, references(:authors, on_delete: :nothing)
      add :repository_id, references(:repositories, on_delete: :nothing)

      timestamps
    end
    create index(:families, [:author_id])
    create index(:families, [:repository_id])

  end
end
