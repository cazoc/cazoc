defmodule Cazoc.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :message, :text
      add :article_id, references(:articles)
      add :author_id, references(:authors)

      timestamps
    end
    create index(:comments, [:article_id])
    create index(:comments, [:author_id])

  end
end
