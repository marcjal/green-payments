defmodule GreenPayments.AccountTest do
  use GreenPayments.DataCase

  alias GreenPayments.Accounts.Account

  doctest GreenPayments.Accounts.Account

  describe "accounts create_changeset/2" do
    @valid_parameters %{
      user_id: Faker.Util.pick(0..100),
      agency: Faker.Util.pick(1000..99_999),
      number: Faker.Util.pick(1000..99_999),
      balance: Faker.Util.pick(0..9_999_999)
    }

    test "with valid parameters" do
      changeset = Account.create_changeset(%Account{}, @valid_parameters)
      assert changeset.valid?
    end

    test "without user_id" do
      params = Map.delete(@valid_parameters, :user_id)
      changeset = Account.create_changeset(%Account{}, params)

      assert !changeset.valid?
      assert Keyword.keys(changeset.errors) == [:user_id]
      error = Keyword.fetch!(changeset.errors, :user_id)
      assert elem(error, 0) == "can't be blank"
    end

    test "without number" do
      params = Map.delete(@valid_parameters, :number)
      changeset = Account.create_changeset(%Account{}, params)

      assert !changeset.valid?
      assert Keyword.keys(changeset.errors) == [:number]
      error = Keyword.fetch!(changeset.errors, :number)
      assert elem(error, 0) == "can't be blank"
    end

    test "without agency" do
      params = Map.delete(@valid_parameters, :agency)
      changeset = Account.create_changeset(%Account{}, params)

      assert !changeset.valid?
      assert Keyword.keys(changeset.errors) == [:agency]
      error = Keyword.fetch!(changeset.errors, :agency)
      assert elem(error, 0) == "can't be blank"
    end

    test "without balance" do
      params = Map.delete(@valid_parameters, :balance)
      changeset = Account.create_changeset(%Account{}, params)

      assert !changeset.valid?
      assert Keyword.keys(changeset.errors) == [:balance]
      error = Keyword.fetch!(changeset.errors, :balance)
      assert elem(error, 0) == "can't be blank"
    end
  end

  describe "accounts update_balance_changeset/3" do
    test ":debit with enough money" do
      changeset = Account.update_balance_changeset(%Account{balance: 1_000}, :debit, 1_000)
      assert changeset.valid?
      assert changeset.changes.balance == 0

      changeset = Account.update_balance_changeset(%Account{balance: 1_000}, :debit, 600)
      assert changeset.valid?
      assert changeset.changes.balance == 400
    end

    test ":debit with not enough money" do
      changeset = Account.update_balance_changeset(%Account{balance: 1_000}, :debit, 1_500)
      assert !changeset.valid?
    end

    test ":debit with not a number" do
      changeset = Account.update_balance_changeset(%Account{balance: 1_000}, :debit, nil)
      assert !changeset.valid?
    end

    test ":debit with negative number" do
      changeset = Account.update_balance_changeset(%Account{balance: 1_000}, :debit, -900)
      assert !changeset.valid?
    end

    test ":debit with zero" do
      changeset = Account.update_balance_changeset(%Account{balance: 1_000}, :debit, 0)
      assert !changeset.valid?
    end

    test ":credit with not a number" do
      changeset = Account.update_balance_changeset(%Account{balance: 1_000}, :credit, "abcd")
      assert !changeset.valid?
    end

    test ":credit with valid data" do
      changeset = Account.update_balance_changeset(%Account{balance: 1_000}, :credit, 1_200)
      assert changeset.valid?
      assert changeset.changes.balance == 2_200
    end
  end
end
