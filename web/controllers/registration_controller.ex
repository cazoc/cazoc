defmodule Cazoc.RegistrationController do
  use Cazoc.Web, :controller
  alias Cazoc.Author

  @doc """
  Author registration
  """
  def new(conn, _params) do
    changeset = Author.changeset(%Author{})
    render conn, "new.html", changeset: changeset
  end

  @doc """
  Create a author
  """
  def create(conn, %{"author" => author_params}) do
    changeset = Author.changeset(%Author{}, author_params)

    Git.init "repositories/" <> changeset.params["name"]
    case Author.create(changeset, Cazoc.Repo) do
      {:ok, author} ->
        conn
        |> put_session(:current_author, author.id)
        |> put_flash(:info, "Welcome to Cazoc! " <> changeset.params["name"])
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Failed to create a account")
        |> render("new.html", changeset: changeset)
    end
  end
end
