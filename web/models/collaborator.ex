defmodule Cazoc.Collaborator do
  use Cazoc.Web, :model

  schema "collaborators" do
    belongs_to :family, Cazoc.Family
    belongs_to :author, Cazoc.Author

    timestamps
  end

  @required_fields ~w()
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
