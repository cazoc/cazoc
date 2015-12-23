defmodule Cazoc.ArticleTest do
  use Cazoc.ModelCase

  alias Cazoc.Article

  @valid_attrs %{abstract: "some content", body: "some content", cover: "some content", published_at: "2010-04-17 14:00:00", title: "some content"}
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
