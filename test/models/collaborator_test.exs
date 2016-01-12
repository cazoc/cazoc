defmodule Cazoc.CollaboratorTest do
  use Cazoc.ModelCase

  alias Cazoc.Collaborator

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Collaborator.changeset(%Collaborator{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Collaborator.changeset(%Collaborator{}, @invalid_attrs)
    refute changeset.valid?
  end
end
