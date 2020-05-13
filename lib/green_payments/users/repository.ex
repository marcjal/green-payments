defmodule GreenPayments.Users.Repository do
  @moduledoc """
  This module implement all interfaces needed
  to interact with user schema and database table
  """

  import Ecto.Query, warn: false

  alias GreenPayments.Repo
  alias GreenPayments.Users.User
  alias GreenPayments.Accounts

  @type signup_data :: %{
          email: String.t(),
          first_name: String.t(),
          last_name: String.t() | nil,
          password: String.t(),
          password_confirmation: String.t(),
          registration_id: String.t()
        }

  @doc """
  Receives a map with user data to be registered on the database

  ## Examples

    iex> {:ok, _} = GreenPayments.Users.Repository.signup(%{
    ...>   email: "marcelo@gmail.com",
    ...>   first_name: "Marcelo",
    ...>   last_name: "Jasek",
    ...>   password: "RD3U3SEAKgzbm9Gu",
    ...>   password_confirmation: "RD3U3SEAKgzbm9Gu",
    ...>   registration_id: "563.606.676-73"
    ...> })
    ...> :ok
    :ok

    iex> {:ok, _} = GreenPayments.Users.Repository.signup(%{
    ...>   email: "marcelo@gmail.com",
    ...>   first_name: "Marcelo",
    ...>   password: "RD3U3SEAKgzbm9Gu",
    ...>   password_confirmation: "RD3U3SEAKgzbm9Gu",
    ...>   registration_id: "563.606.676-73"
    ...> })
    ...> :ok
    :ok
  """
  @spec signup(signup_data()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def signup(attrs) do
    %User{}
    |> User.signup_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Receives an extra argument for agency and calls signup
  and after the account creation step

  ## Examples

    iex> {:ok, _} = GreenPayments.Users.Repository.signup(%{
    ...>   email: "marcelo@gmail.com",
    ...>   first_name: "Marcelo",
    ...>   last_name: "Jasek",
    ...>   password: "RD3U3SEAKgzbm9Gu",
    ...>   password_confirmation: "RD3U3SEAKgzbm9Gu",
    ...>   registration_id: "563.606.676-73"
    ...> })
    ...> :ok
    :ok

    iex> {:ok, {_, _}} = GreenPayments.Users.Repository.signup_with_account(%{
    ...>   email: "marcelo@gmail.com",
    ...>   first_name: "Marcelo",
    ...>   password: "RD3U3SEAKgzbm9Gu",
    ...>   password_confirmation: "RD3U3SEAKgzbm9Gu",
    ...>   registration_id: "563.606.676-73",
    ...> }, 1)
    ...> :ok
    :ok
  """
  @spec signup_with_account(signup_data(), pos_integer()) ::
          {:ok, {User.t(), Accounts.Account.t()}}
          | {:error, {Ecto.Changeset.t(), Ecto.Changeset.t()}}
  def signup_with_account(attrs, agency) do
    Repo.transaction(fn ->
      case signup(attrs) do
        {:ok, user} ->
          cond_create_account(user, agency)

        {:error, changeset} ->
          Repo.rollback({changeset, nil})
      end
    end)
  end

  @doc """
  Receives an email and raw password as arguments
  and searches on database for an user with that email.

  If an user is returned, check if raw password given
  matches encryption for the stored password.

  ## Examples
    iex> {:error, msg} = GreenPayments.Users.Repository.login(
    ...>   "marcelo@gmail.com",
    ...>   "RD3U3SEAKgzbm9Gu"
    ...> )
    ...> msg
    "invalid user and password"

    iex> {:ok, created_user} = GreenPayments.Users.Repository.signup(%{
    ...>   email: "marcelo@gmail.com",
    ...>   first_name: "Marcelo",
    ...>   last_name: "Jasek",
    ...>   password: "RD3U3SEAKgzbm9Gu",
    ...>   password_confirmation: "RD3U3SEAKgzbm9Gu",
    ...>   registration_id: "563.606.676-73"
    ...> })
    ...> {:ok, user} = GreenPayments.Users.Repository.login(
    ...>   "marcelo@gmail.com",
    ...>   "RD3U3SEAKgzbm9Gu"
    ...> )
    ...> assert created_user.id == user.id
    true
  """
  @spec login(String.t(), String.t()) :: {:ok, User.t()} | {:error, String.t()}
  def login(email, password) when is_binary(email) and is_binary(password) do
    with %User{} = user <- find_user_by_email(email),
         true <- User.password_valid?(user, password) do
      {:ok, user}
    else
      _ ->
        {:error, "invalid user and password"}
    end
  end

  def login(_, _) do
    {:error, "invalid user and password"}
  end

  @doc """
  Given an email, returns the user
  associated to it

  ## Examples

      iex> GreenPayments.Users.Repository.find_user_by_email("any@email.com")
      nil
  """
  @spec find_user_by_email(String.t()) :: User.t() | nil
  def find_user_by_email(email) do
    from(u in User, where: u.email == ^email)
    |> Repo.one()
  end

  defp cond_create_account(user, agency) do
    case Accounts.Repository.create_account(user, agency) do
      {:ok, account} ->
        {user, account}

      {:error, changeset} ->
        Repo.rollback({nil, changeset})
    end
  end
end
