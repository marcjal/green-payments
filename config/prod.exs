use Mix.Config

config :green_payments, GreenPaymentsWeb.Endpoint, url: [host: "example.com", port: 80]

config :logger, level: :info

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :green_payments, GreenPayments.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :green_payments, GreenPaymentsWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  url: [scheme: "https", host: "green-payments.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: secret_key_base,
  server: true,
  code_reloader: false

config :green_payments, GreenPayments.Users.Guardian,
  issuer: "green_payments",
  secret_key: secret_key_base
