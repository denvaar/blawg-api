# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :blawg_api, BlawgApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sp/oZU6U20c9VLZpucf9FsFDAO7apX1qjT+duFH//hkGL3myko7kxtDXrDl2igDW",
  render_errors: [view: BlawgApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BlawgApi.PubSub, adapter: Phoenix.PubSub.PG2]

config :blawg_api,
  hmac_key: "secret_key"

config :blawg_api,
  persistance_handler: BlawgPostgresDb

config :blawg_api,
  authentication_handler: BlawgApi.HmacAuthentication

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
