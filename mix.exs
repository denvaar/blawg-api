defmodule BlawgApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :blawg_api,
      version: "0.1.0",
      elixir: "~> 1.9.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        flags: [:unmatched_returns, :error_handling, :race_conditions, :underspecs],
        paths: [
          "_build/dev/lib/blawg_api/ebin"
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {BlawgApi.Application, []},
      extra_applications: [:logger, :runtime_tools, :blawg_postgres_db]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:absinthe, "~> 1.4.2"},
      {:absinthe_phoenix, "~> 1.4.0"},
      {:absinthe_plug, "~> 1.4.0"},
      {:blawg_postgres_db, git: "https://github.com/denvaar/blawg_postgres_db.git"},
      {:cors_plug, "~> 2.0"},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:mox, "~> 0.5", only: :test},
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:scrivener_list, "~> 2.0.1"}
    ]
  end
end
