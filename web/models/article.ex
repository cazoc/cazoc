defmodule Cazoc.Article do
  use Cazoc.Web, :model

  alias Cazoc.{Author, Comment, Repository}

  schema "articles" do
    field :body, :string
    field :title, :string
    field :cover, :string
    field :path, :string
    field :sha, :string
    field :published_at, Timex.Ecto.DateTime
    belongs_to :author, Author
    belongs_to :family, Family
    has_many :comments, Comment, on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(path published_at sha)
  @optional_fields ~w(body cover title)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:path, name: :articles_path_family_id_index)
  end

  def formated_publised_at(model) do
    model.published_at |> Timex.DateFormat.format!("%Y/%m/%d %H:%M", :strftime)
  end

  @doc """
  Title
  """
  def title(model) do
    "title"
  end
end
