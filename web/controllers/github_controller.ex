defmodule Cazoc.GithubController do
  use Cazoc.Web, :controller

  alias Cazoc.{Author, Session}

  def index(conn, _params) do
    author = Session.current_author(conn)
    client = Tentacat.Client.new(%{access_token: Author.token_github(author)})
    repositories = Tentacat.Repositories.list_mine(client)
    |> Enum.map(&(%{name: &1["name"],
                    full_name: &1["full_name"],
                    owner: &1["owner"]["login"],
                    url: &1["html_url"],
                    description: &1["description"]}))
    |> Enum.map(&(%{&1 | name: if(String.starts_with?(&1.full_name, "#{author.name}/"), do: &1.name, else: &1.full_name)}))
    render(conn, :index, repositories: repositories)
  end
end
