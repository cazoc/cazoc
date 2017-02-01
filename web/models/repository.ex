defmodule Cazoc.Repository do
  use Cazoc.Web, :model

  schema "repositories" do
    field :path, :string
    field :source, :string
    field :url, :string

    timestamps()
  end

  @required_fields ~w(path)a
  @optional_fields ~w(source)a

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
