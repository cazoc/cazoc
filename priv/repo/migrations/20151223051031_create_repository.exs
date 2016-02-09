defmodule Cazoc.Repo.Migrations.CreateRepository do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :path, :string
      add :source, :string
      add :url, :string

      timestamps
    end

  end
end
