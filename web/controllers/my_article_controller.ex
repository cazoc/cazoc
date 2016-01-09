defmodule Cazoc.MyArticleController do
  use Cazoc.Web, :controller
  require Logger

  alias Cazoc.Article
  alias Cazoc.Author
  alias Cazoc.Session
  alias Cazoc.Repository
  alias Timex.Date
  alias Timex.DateFormat

  plug :scrub_params, "article" when action in [:create, :update]

  def index(conn, _params) do
    articles = Repo.all from article in Article,
           join: author in assoc(article, :author),
           where: author.id == ^Session.current_author(conn).id,
           preload: [author: author]
    render(conn, "index.html", articles: articles)
  end

  def new(conn, _params) do
    changeset = Article.changeset(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    author = Session.current_author(conn)
    now = Date.now
    dir_name = now |> DateFormat.format!("%Y%m%d%H%M%S", :strftime)
    path = author |> Author.path |> Path.join dir_name
    repository = %Repository{path: path}
    case Repo.insert(repository) do
      {:ok, repository} ->
        published_at = now |> DateFormat.format!("%Y-%m-%d %H:%M:%S", :strftime)
        article = %Article{author_id: author.id, repository_id: repository.id, published_at: now}
        changeset = Article.changeset(article, article_params)
        case Repo.insert(changeset) do
          {:ok, article} ->
            {:ok, repo} = Git.init path
            update_repository(repo, article |> Repo.preload(:repository))
            conn
            |> put_flash(:info, "Article created successfully.")
            |> redirect(to: my_article_path(conn, :index))
          {:error, changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      {:error, repository} ->
        conn
        |> put_flash(:info, "Failed to poste article.")
        |> redirect(to: my_article_path(conn, :index))
    end

  end

  def show(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)
    render(conn, "show.html", article: article)
  end

  def edit(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)
    changeset = Article.changeset(article)
    render(conn, "edit.html", article: article, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = Repo.get!(Article, id) |> Repo.preload(:repository)
    changeset = Article.changeset(article, article_params)

    case Repo.update(changeset) do
      {:ok, article} ->
        %Git.Repository{path: article.repository.path} |> update_repository article

        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: my_article_path(conn, :show, article))
      {:error, changeset} ->
        render(conn, "edit.html", article: article, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = Repo.get!(Article, id) |> Repo.preload(:repository)
    File.rm_rf article.repository.path
    Repo.delete!(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: my_article_path(conn, :index))
  end

  defp update_repository(repo, article) do
    file_name = "index.md"
    Path.join(article.repository.path, file_name) |> File.write article.body
    Git.add repo, "--all"
    Git.commit repo, "-m 'Update'"
  end
end
