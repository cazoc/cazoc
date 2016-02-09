defmodule Cazoc.GithubController do
  use Cazoc.Web, :controller

  alias Cazoc.{Author, Family, Repository, Session}

  def index(conn, _params) do
    author = Session.current_author(conn)
    client = Tentacat.Client.new(%{access_token: Author.token_github(author)})
    families = Tentacat.Repositories.list_mine(client)
    |> Enum.map(&(%Family{name: &1["name"],
                          display_name: &1["full_name"],
                          description: &1["description"],
                          author_id: author.id,
                          repository: %Repository{
                            path: Path.join(author |> Author.path, &1["name"]),
                            url: &1["html_url"],
                            source: &1["clone_url"]
                          }
                         }))
    |> Enum.map(&(%{&1 | name: if(String.starts_with?(&1.display_name, "#{author.name}/"), do: &1.name, else: &1.display_name)}))
    |> Enum.map(&(Family.changeset(&1)))
    render(conn, :index, families: families)
  end

  def import(conn, %{"family" => family_params}) do
    author = Session.current_author(conn)
    IO.inspect family_params
    result = with {:ok, repo} <- Git.clone([family_params["source"], family_params["path"]]),
      repository = Repository.changeset(%Repository{}, family_params),
      {:ok, repository} <- Repo.insert(repository),
      family = Family.changeset(%Family{repository_id: repository.id, author_id: author.id}, family_params),
      {:ok, family} <- Repo.insert(family),
      do: {:ok, family}

    case result do
      {:ok, family} ->
        conn
        |> put_flash(:info, "Repository imported successfully.")
        |> render(conn, :import, family: family)
      {:error, _} ->
        conn
        |> put_flash(:info, "Failed to import repository.")
        |> redirect(to: github_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    familty = Repo.get!(Family, id) |> Repo.preload(:repository)
    File.rm_rf family.repository.path
    Repo.delete!(family)

    conn
    |> put_flash(:info, "Family deleted successfully.")
    |> redirect(to: github_path(conn, :index))
  end
end
