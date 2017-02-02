defmodule Cazoc.Comment do
  use Cazoc.Web, :model

  schema "comments" do
    field :message, :string
    belongs_to :article, Article
    belongs_to :author, Author

    timestamps()
  end

  @required_fields ~w(message)a
  @optional_fields ~w()a

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
