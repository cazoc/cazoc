defmodule Cazoc.Author do
  use Cazoc.Web, :model

  schema "authors" do
    field :name, :string, null: false, uique: true
    field :display_name, :string
    field :icon, :string
    field :url, :string
    field :email, :string, null: false, uique: true
    field :password, :string, null: false
    field :password_tmp, :string
    field :token, :string
    field :ssh_key, :string
    field :type, :integer, defaults: 0
    belongs_to :repository, Cazoc.Repository
    has_many :services, Cazoc.Service, on_delete: :delete_all
    has_many :articles, Cazoc.Article

    timestamps
  end

  @required_fields ~w(name email password)
  @optional_fields ~w(display_name icon url password_tmp token ssh_key type)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
  end

  @doc """
  Create author
  """
  def create(changeset, repo) do
    changeset
    |> put_change(:password, Comeonin.Bcrypt.hashpwsalt(changeset.params["password"]))
    |> repo.insert()
  end
end
