defmodule Cazoc.Session do
  alias Cazoc.Author

  @doc """
  Login
  """
  def login(params, repo) do
    author = repo.get_by(Author, email: String.downcase(params["email"]))
    case authenticate(author, params["password"]) do
      true -> {:ok, author}
      _    -> :error
    end
  end

  defp authenticate(author, password) do
    case author do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, author.password)
    end
  end

  @doc """
  Current author
  """
  def current_author(conn) do
    id = Plug.Conn.get_session(conn, :current_author)
    if id, do: Cazoc.Repo.get(Author, id)
  end

  @doc """
  Check wheather author is logged in or not
  """
  def logged_in?(conn) do
    !!current_author(conn)
  end
end
