defmodule Cazoc.CommentView do
  use Cazoc.Web, :view

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, Cazoc.CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, Cazoc.CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      author: render_one(comment.author, Cazoc.AuthorView, "author.json"),
      message: comment.message}
  end
end
