defmodule Cazoc.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :body, :text
      add :cover, :string
      add :path, :string
      add :published_at, :datetime
      add :author_id, references(:authors)

      timestamps
    end
    create index(:articles, [:author_id])

  end
end
