defmodule Cazoc.AdminView do
  use Cazoc.Web, :view

  def models do
    ["accounts", "authors", "articles", "families", "repositories", "comments"]
  end
end
