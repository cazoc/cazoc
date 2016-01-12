defmodule Cazoc.FamilyTest do
  use Cazoc.ModelCase

  alias Cazoc.Family

  @valid_attrs %{cover: "some content", description: "some content", display_name: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Family.changeset(%Family{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Family.changeset(%Family{}, @invalid_attrs)
    refute changeset.valid?
  end
end
