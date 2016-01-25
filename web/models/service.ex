defmodule Cazoc.Service do
  use Cazoc.Web, :model
  alias Cazoc.{Author, Repo, Service}

  schema "services" do
    field :name, :string
    field :user, :string
    field :token, :string

    belongs_to :author, Cazoc.Author

    timestamps
  end

  @required_fields ~w(name token)
  @optional_fields ~w(user)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def insert_or_update({:ok, author} = result, %Ueberauth.Auth{} = auth) do
    params = %{name: auth.provider |> Atom.to_string,
               token: auth.credentials.token}
    case Repo.get_by(Service, %{name: auth.provider |> Atom.to_string, author_id: author.id}) do
      nil  -> %Service{name: auth.provider, author_id: author.id}
      service -> service
    end
    |> Service.changeset(params)
    |> Repo.insert_or_update
  end
end
