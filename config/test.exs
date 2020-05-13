use Mix.Config

config :green_payments, GreenPayments.Repo,
  username: "postgres",
  password: "",
  database: "green_payments_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :green_payments, GreenPaymentsWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

config :bcrypt_elixir, :log_rounds, 1
