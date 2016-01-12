defmodule Cazoc.CollaboratorControllerTest do
  use Cazoc.ConnCase

  alias Cazoc.Collaborator
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, collaborator_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing collaborators"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, collaborator_path(conn, :new)
    assert html_response(conn, 200) =~ "New collaborator"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, collaborator_path(conn, :create), collaborator: @valid_attrs
    assert redirected_to(conn) == collaborator_path(conn, :index)
    assert Repo.get_by(Collaborator, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, collaborator_path(conn, :create), collaborator: @invalid_attrs
    assert html_response(conn, 200) =~ "New collaborator"
  end

  test "shows chosen resource", %{conn: conn} do
    collaborator = Repo.insert! %Collaborator{}
    conn = get conn, collaborator_path(conn, :show, collaborator)
    assert html_response(conn, 200) =~ "Show collaborator"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, collaborator_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    collaborator = Repo.insert! %Collaborator{}
    conn = get conn, collaborator_path(conn, :edit, collaborator)
    assert html_response(conn, 200) =~ "Edit collaborator"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    collaborator = Repo.insert! %Collaborator{}
    conn = put conn, collaborator_path(conn, :update, collaborator), collaborator: @valid_attrs
    assert redirected_to(conn) == collaborator_path(conn, :show, collaborator)
    assert Repo.get_by(Collaborator, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    collaborator = Repo.insert! %Collaborator{}
    conn = put conn, collaborator_path(conn, :update, collaborator), collaborator: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit collaborator"
  end

  test "deletes chosen resource", %{conn: conn} do
    collaborator = Repo.insert! %Collaborator{}
    conn = delete conn, collaborator_path(conn, :delete, collaborator)
    assert redirected_to(conn) == collaborator_path(conn, :index)
    refute Repo.get(Collaborator, collaborator.id)
  end
end
