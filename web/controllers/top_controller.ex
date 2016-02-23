defmodule Cazoc.TopController do
  use Cazoc.Web, :controller

  alias Cazoc.{Article, Author, Family, Session}

  def index(conn, _params) do
    families = Repo.all from family in Family,
      order_by: family.updated_at

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
