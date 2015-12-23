defmodule Cazoc.ServiceTest do
  use Cazoc.ModelCase

  alias Cazoc.Service

  @valid_attrs %{name: "some content", token: "some content", user: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Service.changeset(%Service{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Service.changeset(%Service{}, @invalid_attrs)
    refute changeset.valid?
  end
end
