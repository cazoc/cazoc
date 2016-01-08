defmodule Cazoc.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :body, :text
      add :cover, :string
      add :published_at, :datetime
      add :author_id, references(:authors)
      add :repository_id, references(:repositories)

      timestamps
    end
    create index(:articles, [:author_id])
    create index(:articles, [:repository_id])

  end
end
