defmodule Cazoc.GithubController do
  use Cazoc.Web, :controller

  alias Cazoc.{Article, Author, Family, Repository, Session}
  alias Timex.{Date, DateFormat}

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
                          }}))
    |> Enum.map(&(%{&1 | name: if(String.starts_with?(&1.display_name, "#{author.name}/"), do: &1.name, else: &1.display_name)}))
    |> Enum.map(&(Family.changeset(&1)))
    render(conn, :index, families: families)
  end

  def import(conn, %{"family" => family_params}) do
    author = Session.current_author(conn)
    result = with {:ok, _} <- Git.clone([family_params["source"], family_params["path"]]),
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

  def sync(conn, %{"family" => family_params}) do
    author = Session.current_author(conn)
    family = Repo.get_by(Family, author_id: author.id, name: family_params["name"])
    family = if is_nil(family), do: %Family{author_id: author.id}, else: family
    family = Family.changeset(family, family_params)
    result = with {:ok, family} <- Repo.insert_or_update(family),
    {:ok, articles, failed_paths} <- download_articles(author, family),
    do: {:ok, articles, failed_paths}

  case result do
    {:ok, _, failed_paths} ->
      message = if length(failed_paths) == 0 do
          "Repository synced successfully."
        else
          "Failed synced following files:\n#{failed_paths |> Enum.join("\n")}"
        end
      conn
      |> put_flash(:info, message)
      |> redirect(to: my_article_path(conn, :index))
    {:error, _} ->
      conn
      |> put_flash(:info, "Failed to sync repository.")
      |> redirect(to: github_path(conn, :index))
  end
  end

  def delete(conn, %{"id" => id}) do
    family = Repo.get!(Family, id) |> Repo.preload(:repository)
    File.rm_rf family.repository.path
    Repo.delete!(family)

    conn
    |> put_flash(:info, "Family deleted successfully.")
    |> redirect(to: github_path(conn, :index))
  end

  defp download_articles(author, family) do
    client = Tentacat.Client.new %{access_token: Author.token_github(author)}
    {owner, repo, branch} = {author.name, family.name, "master"}
    trees = Tentacat.Trees.find_recursive owner, repo, branch, client
    result = trees["tree"]
    |> Enum.filter(&(is_valid_file &1))
    |> Enum.filter(&(is_nil Repo.get_by(Article, family_id: family.id, path: &1["path"], sha: &1["sha"])))
    |> Enum.map(&(download_article author, family, &1["path"]))
    articles = result
    |> Enum.filter(&(elem(&1, 0) == :ok))
    |> Enum.map(&(elem(&1, 1)))
    |> Enum.map(&(&1 |> Repo.preload(:author)))
    failed_paths = result
    |> Enum.filter(&(elem(&1, 0) == :error))
    |> Enum.map(&(elem(&1, 1)))
    {:ok, articles, failed_paths}
  end

  defp download_article(author, family, path) do
    client = Tentacat.Client.new(%{access_token: Author.token_github(author)})
    content = Tentacat.Contents.find(author.name, family.name, path, client)
    if is_valid_content(content) do
      body = content["content"]
      |> String.split("\n", trim: true)
      |> Enum.map(&(Base.decode64(&1)))
      |> Enum.map(&(elem(&1, 1)))
      |> Enum.join
      title = parse_title body, path
      IO.inspect title
      article_params = %{body: body, published_at: Ecto.DateTime.local, path: path, sha: content["sha"], title: title}
      article = Repo.get_by(Article, family_id: family.id, path: path)
      if is_nil(article), do: article = %Article{author_id: author.id, family_id: family.id}
      Article.changeset(article, article_params)
      |> Repo.insert_or_update
    else
      IO.inspect content
      {:error, path}
    end
  end

  defp parse_title(body, path) do
    default = "Title"
    pattern = title_pattern Article.format(path)
    if pattern do
      captured = Regex.named_captures(pattern, body, capture: :first)
      if captured, do: captured["title"], else: default
    else
      default
    end
  end

  defp title_pattern(format) do
    case format do
      :org -> ~r/#\+title: (?<title>[^\n]+)/i
      :md -> ~r/^% (?<title>[^\n]+)/
      :other -> nil
    end
  end

  defp is_valid_content(content) do
    is_map(content) and content["encoding"] == "base64" and content["type"] == "file"
  end

  defp is_valid_file(file) do
    file["type"] == "blob" and Article.is_valid_format(file["path"])
  end
end
