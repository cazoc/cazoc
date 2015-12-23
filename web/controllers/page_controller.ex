defmodule Cazoc.PageController do
  use Cazoc.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
