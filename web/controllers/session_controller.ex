defmodule Cazoc.SessionController do
  use Cazoc.Web, :controller

  @doc """
  Login form
  """
  def new(conn, _params) do
    render conn, "new.html"
  end

  @doc """
  Login
  """
  def create(conn, %{"session" => session_params}) do
    case Session.login(session_params, Repo) do
      {:ok, author} ->
        conn
        |> put_session(:current_author, author.id)
        |> put_flash(:info, "Logged in successfully")
        |> redirect(to: "/")
      :error ->
        conn
        |> put_flash(:info, "Invalid email or password")
        |> render("new.html")
    end
  end

  @doc """
  Logout
  """
  def delete(conn, _) do
    conn
    |> delete_session(:current_author)
    |> put_flash(:info, "Logged out successfully")
    |> redirect(to: "/")
  end
end
