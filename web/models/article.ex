defmodule Cazoc.Article do
  use Cazoc.Web, :model

  schema "articles" do
    field :body, :string
    field :title, :string
    field :cover, :string
    field :path, :string
    field :sha, :string
    field :uuid, :string
    field :published_at, Timex.Ecto.DateTime
    belongs_to :author, Author
    belongs_to :family, Family
    has_many :comments, Comment, on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(path published_at sha uuid)a
  @optional_fields ~w(body cover title)a

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:path, name: :articles_path_family_id_index)
  end

  @doc """
  Formmatted string of published_at
  """
  def formated_publised_at(model) do
    model.published_at
    |> Timex.format!("%Y/%m/%d", :strftime)
  end

  @doc """
  Convert to HTML
  """
  def html_body(model) do
    case format(model.path) do
      :org -> Pandex.convert_string model.body, "org"
      :md -> Pandex.convert_string model.body
      :other -> model.body
    end
  end

  @doc """
  File format type
  """
  def format(path) do
    cond do
      path =~ ~r/.+\.org$/ -> :org
      path =~ ~r/.+\.(md|markdown)$/ -> :md
      true -> :other
    end
  end

  def is_valid_format(path) do
    path =~ ~r/.+\.(md|markdown|org)$/
  end
end
