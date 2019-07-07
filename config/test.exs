use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :blawg_api, BlawgApiWeb.Endpoint,
  http: [port: 4002],
  server: false

config :blawg_api,
  persistance_handler: BlawgApi.MockPersistance
config :blawg_api,
  authentication_handler: BlawgApi.MockAuthentication
config :blawg_api,
  hmac_key: "secret_key"

config :blawg_postgres_db, BlawgPostgresDb.Repo,
  username: "postgres",
  password: "postgres",
  database: "blawg_postgres_db_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :warn
