defmodule BlawgApi.Repo do
  use Ecto.Repo,
    otp_app: :blawg_api,
    adapter: Ecto.Adapters.Postgres
end
