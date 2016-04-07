defmodule Cazoc.TopController do
  use Cazoc.Web, :controller

  alias Cazoc.{Article, Author, Family, Session}

  def index(conn, _params) do
    families = if Session.logged_in?(conn) do
      Repo.all from family in Family,
      join: author in assoc(family, :author),
      where: author.id == ^Session.current_author(conn).id,
      preload: [author: author],
      order_by: family.updated_at
    else
      []
    end

    articles = Repo.all from article in Article,
      join: author in assoc(article, :author),
      order_by: article.published_at,
      limit: 7,
      preload: [author: author]

    render conn, "index.html", articles: articles, families: families
  end

  def repositories_github(conn, _params) do
    author = Session.current_author(conn)
    client = Tentacat.Client.new(%{access_token: Author.token_github(author)})
    repositories = Tentacat.Repositories.list_mine(client) |> Enum.map(&(%{name: &1["name"], url: &1["url"]}))
    render conn, "index.html", repositories: repositories
  end
end
