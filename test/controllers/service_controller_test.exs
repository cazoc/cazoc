defmodule Cazoc.ServiceControllerTest do
  use Cazoc.ConnCase

  alias Cazoc.Service
  @valid_attrs %{name: "some content", token: "some content", user: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, service_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing services"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, service_path(conn, :new)
    assert html_response(conn, 200) =~ "New service"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, service_path(conn, :create), service: @valid_attrs
    assert redirected_to(conn) == service_path(conn, :index)
    assert Repo.get_by(Service, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, service_path(conn, :create), service: @invalid_attrs
    assert html_response(conn, 200) =~ "New service"
  end

  test "shows chosen resource", %{conn: conn} do
    service = Repo.insert! %Service{}
    conn = get conn, service_path(conn, :show, service)
    assert html_response(conn, 200) =~ "Show service"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, service_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    service = Repo.insert! %Service{}
    conn = get conn, service_path(conn, :edit, service)
    assert html_response(conn, 200) =~ "Edit service"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    service = Repo.insert! %Service{}
    conn = put conn, service_path(conn, :update, service), service: @valid_attrs
    assert redirected_to(conn) == service_path(conn, :show, service)
    assert Repo.get_by(Service, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    service = Repo.insert! %Service{}
    conn = put conn, service_path(conn, :update, service), service: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit service"
  end

  test "deletes chosen resource", %{conn: conn} do
    service = Repo.insert! %Service{}
    conn = delete conn, service_path(conn, :delete, service)
    assert redirected_to(conn) == service_path(conn, :index)
    refute Repo.get(Service, service.id)
  end
end
