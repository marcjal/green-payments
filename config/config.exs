use Mix.Config

config :green_payments,
  ecto_repos: [GreenPayments.Repo]

config :green_payments, GreenPaymentsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lW1f7kW4iif4s5He7YcsorXuEz+yotCHB1+c0HnzYPZkdNRsBExObGhTX7d4gHta",
  render_errors: [view: GreenPaymentsWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: GreenPayments.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :green_payments, GreenPayments.Users.Guardian,
  issuer: "green_payments",
  secret_key: "Secret key. You can use `mix guardian.gen.secret` to get one"

import_config "#{Mix.env()}.exs"
