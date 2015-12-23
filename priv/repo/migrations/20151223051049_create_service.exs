defmodule Cazoc.Repo.Migrations.CreateService do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :name, :string
      add :user, :string
      add :token, :string

      timestamps
    end

  end
end
