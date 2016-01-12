defmodule Cazoc.FamilyControllerTest do
  use Cazoc.ConnCase

  alias Cazoc.Family
  @valid_attrs %{cover: "some content", description: "some content", display_name: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, family_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing families"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, family_path(conn, :new)
    assert html_response(conn, 200) =~ "New family"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, family_path(conn, :create), family: @valid_attrs
    assert redirected_to(conn) == family_path(conn, :index)
    assert Repo.get_by(Family, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, family_path(conn, :create), family: @invalid_attrs
    assert html_response(conn, 200) =~ "New family"
  end

  test "shows chosen resource", %{conn: conn} do
    family = Repo.insert! %Family{}
    conn = get conn, family_path(conn, :show, family)
    assert html_response(conn, 200) =~ "Show family"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, family_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    family = Repo.insert! %Family{}
    conn = get conn, family_path(conn, :edit, family)
    assert html_response(conn, 200) =~ "Edit family"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    family = Repo.insert! %Family{}
    conn = put conn, family_path(conn, :update, family), family: @valid_attrs
    assert redirected_to(conn) == family_path(conn, :show, family)
    assert Repo.get_by(Family, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    family = Repo.insert! %Family{}
    conn = put conn, family_path(conn, :update, family), family: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit family"
  end

  test "deletes chosen resource", %{conn: conn} do
    family = Repo.insert! %Family{}
    conn = delete conn, family_path(conn, :delete, family)
    assert redirected_to(conn) == family_path(conn, :index)
    refute Repo.get(Family, family.id)
  end
end
