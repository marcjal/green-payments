defmodule GreenPayments.Repo do
  use Ecto.Repo,
    otp_app: :green_payments,
    adapter: Ecto.Adapters.Postgres
end
