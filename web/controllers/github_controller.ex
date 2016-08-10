defmodule Cazoc.GithubController do
  use Cazoc.Web, :controller

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
    result = with {:ok, repository} <- insert_or_update_repository(author, family_params),
      {:ok, family} <- insert_or_update_family(author, family_params, repository),
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

  defp insert_or_update_repository(author, family_params) do
    case Repo.get_by(Family, author_id: author.id, name: family_params["name"]) do
      nil -> %Repository{}
      family -> Repo.preload(family, :repository).repository
    end
    |> Repository.changeset(family_params)
    |> Repo.insert_or_update
  end

  defp insert_or_update_family(author, family_params, repository) do
    case Repo.get_by(Family, author_id: author.id, name: family_params["name"]) do
      nil -> %Family{author_id: author.id, repository_id: repository.id}
      family -> family
    end
    |> Family.changeset(family_params)
    |> Repo.insert_or_update
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
      date = parse_date body, path
      article_params = %{body: body, published_at: date, path: path, sha: content["sha"], title: title}
      case Repo.get_by(Article, family_id: family.id, path: path) do
        nil ->  %Article{author_id: author.id, family_id: family.id, uuid: generate_uuid()}
        article -> article
      end
      |> Article.changeset(article_params)
      |> Repo.insert_or_update
    else
      {:error, path}
    end
  end

  defp parse_title(body, path) do
    default = "Title"
    pattern = title_pattern Article.format(path)
    captured = Regex.named_captures(pattern, body, capture: :first)
    if captured, do: captured["title"], else: default
  end

  defp parse_date(body, path) do
    default = Timex.now
    pattern = date_pattern Article.format(path)
    captured = Regex.named_captures(pattern, body, capture: :first)
    if captured do
      case Timex.parse(captured["date"], "{YYYY}-{M}-{D}") do
        {:ok, date} -> date
        {:error, _} -> default
      end
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

  defp date_pattern(format) do
    case format do
      :org -> ~r/#\+date: (?<date>[^\n]+)/i
      :md -> ~r/^% (?<date>[^\n]+)/
      :other -> nil
    end
  end

  defp is_valid_content(content) do
    is_map(content) and content["encoding"] == "base64" and content["type"] == "file"
  end

  defp is_valid_file(file) do
    file["type"] == "blob" and Article.is_valid_format(file["path"])
  end

  defp generate_uuid() do
    uuid = SecureRandom.urlsafe_base64(8)
    case Repo.get_by(Article, uuid: uuid) do
      nil -> uuid
      _ -> generate_uuid()
    end
  end
end
