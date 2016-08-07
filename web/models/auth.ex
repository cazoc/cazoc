defmodule Cazoc.Auth do
  use Cazoc.Web, :model

  def insert_or_update(%Ueberauth.Auth{} = auth) do
    name = name_from_auth(auth)
    params = %{email: auth.info.email,
               display_name: auth.info.nickname,
               icon: auth.info.urls.avatar_url,
               url: auth.info.urls.blog}
    case Repo.get_by(Author, name: name) do
      nil  -> %Author{name: name}
      author -> author
    end
    |> Author.changeset_auth(params)
    |> Repo.insert_or_update
    |> Service.insert_or_update(auth)
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))
      if length(name) == 0, do: auth.info.nickname, else: name = Enum.join(name, " ")
    end
  end
end
