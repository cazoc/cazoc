defmodule Cazoc.AuthorView do
  use Cazoc.Web, :view

  def render("index.json", %{authors: authors}) do
    %{data: render_many(authors, Cazoc.AuthorView, "author.json")}
  end

  def render("show.json", %{author: author}) do
    %{data: render_one(author, Cazoc.AuthorView, "author.json")}
  end

  def render("author.json", %{author: author}) do
    %{id: author.id,
      icon: author.icon,
      url: author.url,
      name: author.name,
      display_name: author.display_name}
  end
end
