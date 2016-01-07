defmodule Cazoc.ArticleTest do
  use Cazoc.ModelCase

  alias Cazoc.Article

  @valid_attrs %{body: "some content", cover: "some content", published_at: "2016-01-07 08:44:53", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Article.changeset(%Article{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Article.changeset(%Article{}, @invalid_attrs)
    refute changeset.valid?
  end
end
