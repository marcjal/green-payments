defmodule GreenPayments.Accounts.AccountHistory do
  @moduledoc """
  This module holds the database structure
  and logic for bank account operation history.

  It holds information related to an account and
  register the amount that was credited or
  debited, always as positive values.
  """

  @type t :: %__MODULE__{}

  @derive {Jason.Encoder,
           only: [
             :type,
             :amount
           ]}

  alias GreenPayments.Accounts.Account

  use Ecto.Schema
  import Ecto.Changeset

  schema "account_histories" do
    field(:type, :string, null: false)
    field(:amount, :integer, null: false)

    belongs_to :account, Account

    timestamps()
  end

  @doc """
  Receive attributes that describe an account't transaction,
  including operation type (credit or debit) and the value

  ## Examples

      iex> changeset = GreenPayments.Accounts.AccountHistory.create_changeset(
      ...>   %GreenPayments.Accounts.AccountHistory{},
      ...>   %{type: "debit", account_id: 1, amount: 3000}
      ...> )
      ...> changeset.valid?
      true

      iex> changeset = GreenPayments.Accounts.AccountHistory.create_changeset(
      ...>   %GreenPayments.Accounts.AccountHistory{},
      ...>   %{type: "loan", account_id: 1, amount: 200}
      ...> )
      ...> changeset.valid?
      false
  """
  @spec create_changeset(GreenPayments.Accounts.AccountHistory.t(), map()) :: Ecto.Changeset.t()
  def create_changeset(%__MODULE__{} = account_history, attrs) do
    account_history
    |> cast(attrs, [:type, :amount, :account_id])
    |> validate_required([:type, :amount, :account_id])
    |> foreign_key_constraint(:account_id)
    |> validate_inclusion(:type, ~w(credit debit))
    |> validate_number(:amount, greater_than: 0)
  end
end
