defmodule Cazoc.Repo.Migrations.AddFamilyToArticles do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :family_id, references(:families, on_delete: :nothing)
    end
    create index(:articles, [:family_id])

  end
end
