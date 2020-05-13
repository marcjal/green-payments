defmodule GreenPaymentsWeb.Router do
  use GreenPaymentsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :with_auth do
    plug Guardian.Plug.Pipeline,
      module: GreenPayments.Users.Guardian,
      error_handler: GreenPaymentsWeb.GuardianErrorHandler

    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  scope "/api/v1", GreenPaymentsWeb do
    pipe_through :api

    post "/signup", AuthenticationController, :signup
    post "/login", AuthenticationController, :login

    scope "/accounts", Accounts do
      pipe_through :with_auth

      get "/:account_id/history", HistoryController, :index
      post "/:account_id/transactions/withdraw", TransactionController, :withdraw
      post "/:account_id/transactions/transfer/:credit_account_id",
           TransactionController,
           :transfer
    end
  end
end
