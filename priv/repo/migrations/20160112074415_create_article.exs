defmodule Cazoc.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :body, :text
      add :title, :string
      add :cover, :string
      add :path, :string
      add :sha, :string
      add :uuid, :string
      add :published_at, :datetime
      add :author_id, references(:authors)
      add :family_id, references(:families)

      timestamps
    end
    create index(:articles, [:author_id])
    create index(:articles, [:family_id])
    create unique_index(:articles, [:path, :family_id], name: :articles_path_family_id_index)
    create unique_index(:articles, [:uuid])

  end
end
