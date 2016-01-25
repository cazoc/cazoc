defmodule Cazoc.Repo.Migrations.CreateAuthor do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name, :string
      add :display_name, :string
      add :icon, :string
      add :url, :string
      add :email, :string
      add :password, :string
      add :password_tmp, :string
      add :token, :string
      add :ssh_key, :string
      add :type, :integer
      add :repository_id, references(:repositories)

      timestamps
    end
    create index(:authors, [:repository_id])
    create unique_index(:authors, [:email])
    create unique_index(:authors, [:name])

  end
end
