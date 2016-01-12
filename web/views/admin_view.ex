defmodule Cazoc.AdminView do
  use Cazoc.Web, :view

  def models do
    ["authors", "articles", "collaborators", "families", "services", "repositories", "comments"]
  end
end
