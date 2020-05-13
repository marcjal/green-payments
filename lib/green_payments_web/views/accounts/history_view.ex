defmodule GreenPaymentsWeb.Accounts.HistoryView do
  use GreenPaymentsWeb, :view

  def render("history.json", %{history: history}) do
    %{history: history, error: false}
  end

  def render("account_not_found.json", _data) do
    %{error: "account not found"}
  end
end
