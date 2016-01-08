defmodule Cazoc.AuthorTest do
  use Cazoc.ModelCase

  alias Cazoc.Author

  @valid_attrs %{display_name: "some content", email: "some@content", icon: "some content", name: "some content", password: "some content", password_tmp: "some content", ssh_key: "some content", token: "some content", type: 42, url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Author.changeset(%Author{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Author.changeset(%Author{}, @invalid_attrs)
    refute changeset.valid?
  end
end
