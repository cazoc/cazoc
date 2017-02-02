defmodule Cazoc.Author do
  use Cazoc.Web, :model

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
    has_many :articles, Article, on_delete: :nothing
    has_many :families, Family, on_delete: :nothing
    has_many :services, Service, on_delete: :delete_all

    timestamps()
  end

  @required_fields ~w(email name password)a
  @optional_fields ~w(display_name icon url password_tmp token ssh_key type)a
  @required_fields_auth ~w(name)a
  @optional_fields_auth ~w(email display_name icon url password password_tmp token ssh_key type)a

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
    |> unique_constraint(:name)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> validate_length(:name, min: 3)
  end

  def changeset_auth(model, params \\ %{}) do
    model
    |> cast(params, @required_fields_auth ++ @optional_fields_auth)
    |> validate_required(@required_fields_auth)
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

  @doc """
  GitHub token
  """
  def token_github(model) do
    service = Repo.get_by(Service, %{author_id: model.id, name: "github"})
    if service, do: service.token
  end
end
