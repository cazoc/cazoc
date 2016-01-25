defmodule Cazoc.Mixfile do
  use Mix.Project

  def project do
    [app: :cazoc,
     version: "0.0.1",
     elixir: "~> 1.2.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Cazoc, []},
     applications: [:comeonin,
                    :connection,
                    :cowboy,
                    :gettext,
                    :git_cli,
                    :logger,
                    :phoenix, :phoenix_ecto, :phoenix_html, :phoenix_slime,
                    :postgrex,
                    :timex_ecto,
                    :tzdata,
                    :ueberauth,
                    :ueberauth_github]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [{:phoenix, "~> 1.1"},
     {:phoenix_ecto, "~> 2.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.4"},
     {:phoenix_slime, "~> 0.4.1"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"},
     {:comeonin, "~> 1.6.0"},
     {:exrm, "~> 1.0.0-rc7"},
     {:git_cli, "~> 0.1.0"},
     {:pandex, "~> 0.1.0"},
     {:timex, "~> 1.0.0"},
     {:timex_ecto, "~> 0.7.0"},
     {:ueberauth, "~> 0.2"},
     {:ueberauth_github, "~> 0.2"}
    ]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
