# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :cazoc, Cazoc.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "B+pYAkyrzZdtphk5FWTksy7mRAhTm1XClnUbXO8Z0S2fm6rkKjiUeGhr2cL0tI6+",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Cazoc.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configure for ecto repo
config :cazoc, ecto_repos: [Cazoc.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

config :ueberauth, Ueberauth,
  providers: [
    github: { Ueberauth.Strategy.Github, [default_scope: "user:email,public_repo"] }
  ]

config :ex_admin,
  repo: Cazoc.Repo,
  module: Cazoc,
  theme: ExAdmin.Theme.ActiveAdmin,
  modules: [
    Cazoc.ExAdmin.Dashboard,
    Cazoc.ExAdmin.Article,
    Cazoc.ExAdmin.Author,
    Cazoc.ExAdmin.Comment,
    Cazoc.ExAdmin.Collaborator,
    Cazoc.ExAdmin.Family,
    Cazoc.ExAdmin.Repository,
    Cazoc.ExAdmin.Service
  ]

config :xain, :quote, "'"
config :xain, :after_callback, {Phoenix.HTML, :raw}
