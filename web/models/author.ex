defmodule Cazoc.Author do
  use Cazoc.Web, :model

  alias Cazoc.{Article, Family, Service}

  schema "authors" do
    field :name, :string, null: false, uique: true
    field :display_name, :string
    field :icon, :string
    field :url, :string
    field :email, :string, uique: true
    field :password, :string
    field :password_tmp, :string
    field :token, :string
    field :ssh_key, :string
    field :type, :integer, defaults: 0
    has_many :articles, Article, on_delete: :delete_all
    has_many :families, Family, on_delete: :delete_all
    has_many :services, Service, on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(email name password)
  @optional_fields ~w(display_name icon url password_tmp token ssh_key type)
  @required_fields_auth ~w(name)
  @optional_fields_auth ~w(email display_name icon url password password_tmp token ssh_key type)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
    |> unique_constraint(:name)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> validate_length(:name, min: 3)
  end

  def changeset_auth(model, params \\ :empty) do
    model
    |> cast(params, @required_fields_auth, @optional_fields_auth)
    |> unique_constraint(:name)
  end

  @doc """
  Create author
  """
  def create(changeset, repo) do
    changeset
    |> put_change(:password, Comeonin.Bcrypt.hashpwsalt(changeset.params["password"]))
    |> repo.insert()
  end

  @doc """
  Repository path
  """
  def path(model) do
    Path.join("repositories", model.name)
  end
end
