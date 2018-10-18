# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ledger,
  ecto_repos: [Ledger.Repo]

# Configures the endpoint
config :ledger, LedgerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4Vhf4coXhJr1QjUltiRnjhLiwoKq9bBpQNhEXV7xm3Nl8ouWGAG6WBjPq0vqOJTJ",
  render_errors: [view: LedgerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ledger.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :money,
  default_currency: :USD,
  separator: ",",
  delimeter: ".",
  symbol: true,
  symbol_on_right: false,
  symbol_space: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
