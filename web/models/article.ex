defmodule Cazoc.Article do
  use Cazoc.Web, :model

  schema "articles" do
    field :title, :string
    field :abstract, :string
    field :body, :string
    field :cover, :string
    field :published_at, Ecto.DateTime
    belongs_to :author, Cazoc.Author
    belongs_to :repository, Cazoc.Repository

    timestamps
  end

  @required_fields ~w(title abstract body cover published_at)
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
