defmodule Cazoc.Repo do
  use Ecto.Repo, otp_app: :cazoc
  use Scrivener, page_size: 10
end
