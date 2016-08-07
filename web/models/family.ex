defmodule Cazoc.Family do
  use Cazoc.Web, :model

  schema "families" do
    field :name, :string
    field :display_name, :string
    field :description, :string
    field :cover, :string
    belongs_to :author, Author
    belongs_to :repository, Repository
    has_many :articles, Article
    has_many :collaborators, Collaborator

    timestamps
  end

  @required_fields ~w(name display_name)a
  @optional_fields ~w(cover description)a

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name, name: :families_name_author_id_index)
  end
end
