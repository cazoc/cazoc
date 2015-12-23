defmodule Cazoc.Repo.Migrations.CreateRepository do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :path, :string

      timestamps
    end

  end
end
