defmodule Cazoc.SearchController do
  use Cazoc.Web, :controller

  def index(conn, %{"search" => search_params}) do
    keywords = search_params["keyword"]
    articles = Repo.all from article in Article,
           join: author in assoc(article, :author),
           where: like(article.body, ^"%#{keywords}%"),
           preload: [author: author]
    render(conn, "index.html", articles: articles)
  end
end
