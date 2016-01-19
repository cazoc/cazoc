defmodule Cazoc.TopController do
  use Cazoc.Web, :controller

  alias Cazoc.{Article, Author}

  def index(conn, _params) do
    articles = Repo.all from article in Article,
      join: author in assoc(article, :author),
      order_by: article.published_at,
      limit: 7,
      preload: [author: author]
    render conn, "index.html", articles: articles
  end
end
