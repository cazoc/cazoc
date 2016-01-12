defmodule Cazoc.CollaboratorController do
  use Cazoc.Web, :controller

  alias Cazoc.Collaborator

  plug :scrub_params, "collaborator" when action in [:create, :update]

  def index(conn, _params) do
    collaborators = Repo.all(Collaborator)
    render(conn, "index.html", collaborators: collaborators)
  end

  def new(conn, _params) do
    changeset = Collaborator.changeset(%Collaborator{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"collaborator" => collaborator_params}) do
    changeset = Collaborator.changeset(%Collaborator{}, collaborator_params)

    case Repo.insert(changeset) do
      {:ok, _collaborator} ->
        conn
        |> put_flash(:info, "Collaborator created successfully.")
        |> redirect(to: collaborator_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    collaborator = Repo.get!(Collaborator, id)
    render(conn, "show.html", collaborator: collaborator)
  end

  def edit(conn, %{"id" => id}) do
    collaborator = Repo.get!(Collaborator, id)
    changeset = Collaborator.changeset(collaborator)
    render(conn, "edit.html", collaborator: collaborator, changeset: changeset)
  end

  def update(conn, %{"id" => id, "collaborator" => collaborator_params}) do
    collaborator = Repo.get!(Collaborator, id)
    changeset = Collaborator.changeset(collaborator, collaborator_params)

    case Repo.update(changeset) do
      {:ok, collaborator} ->
        conn
        |> put_flash(:info, "Collaborator updated successfully.")
        |> redirect(to: collaborator_path(conn, :show, collaborator))
      {:error, changeset} ->
        render(conn, "edit.html", collaborator: collaborator, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    collaborator = Repo.get!(Collaborator, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(collaborator)

    conn
    |> put_flash(:info, "Collaborator deleted successfully.")
    |> redirect(to: collaborator_path(conn, :index))
  end
end
