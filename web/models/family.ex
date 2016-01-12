defmodule Cazoc.Family do
  use Cazoc.Web, :model

  schema "families" do
    field :name, :string
    field :display_name, :string
    field :description, :string
    field :cover, :string
    belongs_to :author, Cazoc.Author

    timestamps
  end

  @required_fields ~w(name display_name description cover)
  @optional_fields ~w()

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
