defmodule Cazoc.MyArticleView do
  use Cazoc.Web, :view

  def parse_markdown(markdown) do
    Earmark.to_html(markdown)
  end
end
