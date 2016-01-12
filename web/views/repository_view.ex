defmodule Cazoc.RepositoryView do
  use Cazoc.Web, :view

  def render("index.json", %{repositories: repositories}) do
    %{data: render_many(repositories, Cazoc.RepositoryView, "repository.json")}
  end

  def render("show.json", %{repository: repository}) do
    %{data: render_one(repository, Cazoc.RepositoryView, "repository.json")}
  end

  def render("repository.json", %{repository: repository}) do
    %{id: repository.id,
      path: repository.path}
  end
end
