defmodule Cazoc.Mixfile do
  use Mix.Project

  def project do
    [app: :cazoc,
     version: "0.1.0",
     elixir: "~> 1.2",
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
                    :ex_admin,
                    :gettext,
                    :git_cli,
                    :logger,
                    :pandex,
                    :phoenix, :phoenix_ecto, :phoenix_html, :phoenix_slime, :phoenix_live_reload,
                    :postgrex,
                    :scrivener,
                    :tentacat,
                    :timex,
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
     {:phoenix_slime, "~> 0.5"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.10"},
     {:cowboy, "~> 1.0"},
     {:comeonin, "~> 2.4"},
     {:ecto, "~> 1.1 or ~> 2.0", [optional: false, hex: :ecto, manager: :mix, override: true]},
     {:exrm, "~> 1.0.4"},
     {:ex_admin, github: "smpallen99/ex_admin"},
     {:git_cli, "~> 0.2"},
     {:pandex, "~> 0.1.0"},
     {:tentacat, "~> 0.5"},
     {:timex, "~> 2.1"},
     {:timex_ecto, "~> 1.0"},
     {:ueberauth, "~> 0.2"},
     {:ueberauth_github, "~> 0.2"}
    ]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
