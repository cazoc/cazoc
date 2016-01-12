defmodule Cazoc.ArticleView do
  use Cazoc.Web, :view

  def render("index.json", %{articles: articles}) do
    %{data: render_many(articles, Cazoc.ArticleView, "article.json")}
  end

  def render("show.json", %{article: article}) do
    %{data: render_one(article, Cazoc.ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{id: article.id,
      title: article.title,
      cover: article.cover,
      body: article.body,
      comments: render_many(article.comments, Cazoc.ArticleView, "article.json"),
      author: render_one(article.author, Cazoc.AuthorView, "author.json"),
      repository: render_one(article.repository, Cazoc.RepositoryView, "repository.json")}
  end
end
