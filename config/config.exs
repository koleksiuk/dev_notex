# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :dev_notex,
  ecto_repos: [DevNotex.Repo]

# Configures the endpoint
config :dev_notex, DevNotex.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "laO9DBOW1em+YsUSPX+t9dvXRQEJqiCz2iNy1V3c9aDfzjA9MxLFQIsB6dztX2gg",
  render_errors: [view: DevNotex.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DevNotex.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
