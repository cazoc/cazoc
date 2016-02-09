defmodule Cazoc.Repository do
  use Cazoc.Web, :model

  schema "repositories" do
    field :path, :string
    field :source, :string
    field :url, :string

    timestamps
  end

  @required_fields ~w(path)
  @optional_fields ~w(source)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
