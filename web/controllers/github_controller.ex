defmodule Cazoc.GithubController do
  use Cazoc.Web, :controller

  alias Cazoc.{Author, Session}

  def repositories_github(conn, _params) do
    author = Session.current_author(conn)
    client = Tentacat.Client.new(%{access_token: Author.token_github(author)})
    repositories = Tentacat.Repositories.list_mine(client) |> Enum.map(&(%{name: &1["name"], url: &1["url"]}))
    render conn, "index.html", repositories: repositories
  end
end
