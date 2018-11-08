use Mix.Config

config :ledger, LedgerWeb.Endpoint,
  load_from_system_env: true,
  url: [host: "localhost", port: 4000],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

import_config "prod.secret.exs"
