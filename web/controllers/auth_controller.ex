defmodule Cazoc.AuthController do
  use Cazoc.Web, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, :request, callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{ assigns: %{ ueberauth_failure: _fails } } = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{ assigns: %{ ueberauth_auth: auth } } = conn, _params) do
    case Auth.insert_or_update(auth) do
      {:ok, service} ->
        service = service |> Repo.preload(:author)
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_author, service.author.id)
        |> redirect(to: "/")
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Failed to authenticate.")
        |> redirect(to: "/")
    end
  end
end
