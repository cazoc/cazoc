defmodule Cazoc.ArticleController do
  use Cazoc.Web, :controller

  alias Cazoc.Article

  plug :scrub_params, "article" when action in [:create, :update]

  def index(conn, _params) do
    articles = Repo.all(Article) |> Repo.preload(:repository) |> Repo.preload(:author) |> Repo.preload(:comments)
    render(conn, :index, articles: articles)
  end

  def new(conn, _params) do
    changeset = Article.changeset(%Article{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    changeset = Article.changeset(%Article{}, article_params)

    case Repo.insert(changeset) do
      {:ok, _article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: article_path(conn, :index))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    article = Repo.get!(Article, id) |> Repo.preload(:repository) |> Repo.preload(:author) |> Repo.preload(:comments)
    render(conn, :show, article: article)
  end

  def edit(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)
    changeset = Article.changeset(article)
    render(conn, :edit, article: article, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = Repo.get!(Article, id)
    changeset = Article.changeset(article, article_params)

    case Repo.update(changeset) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: article_path(conn, :show, article))
      {:error, changeset} ->
        render(conn, :edit, article: article, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: article_path(conn, :index))
  end
end
