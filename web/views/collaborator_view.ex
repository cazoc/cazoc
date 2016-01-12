defmodule Cazoc.CollaboratorView do
  use Cazoc.Web, :view

  def render("index.json", %{collaborators: collaborators}) do
    %{data: render_many(collaborators, Cazoc.CollaboratorView, "collaborator.json")}
  end

  def render("show.json", %{collaborator: collaborator}) do
    %{data: render_one(collaborator, Cazoc.CollaboratorView, "collaborator.json")}
  end

  def render("collaborator.json", %{collaborator: collaborator}) do
    %{author: render_one(collaborator.author, Cazoc.AuthorView, "author.json")}
  end
end
