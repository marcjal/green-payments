defmodule GreenPayments.Users.User do
  @moduledoc """
  This module holds the database structure
  and logic for bank users (clients).

  Operations made by an user and handled by user
  schema logic are registration and authentication
  """

  @type t :: %__MODULE__{}

  @derive {Jason.Encoder,
           only: [
             :id,
             :first_name,
             :last_name,
             :registration_id,
             :email
           ]}

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:first_name, :string, null: false)
    field(:last_name, :string)
    field(:registration_id, :string, null: false)
    field(:email, :string, null: false)
    field(:encrypted_password, :string, null: false)

    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)

    has_many(:accounts, GreenPayments.Accounts.Account)

    timestamps()
  end

  @doc """
  Receives a argument containing a raw struct for current module
  and a map of values with fields to be inserted.

  ## Examples

      iex> changeset = GreenPayments.Users.User.signup_changeset(%GreenPayments.Users.User{}, %{
      ...>   first_name: "Marcelo",
      ...>   last_name: "Jasek",
      ...>   registration_id: "563.606.676-73",
      ...>   email: "marcelo@gmail.com",
      ...>   password: "abcdefg",
      ...>   password_confirmation: "abcdefg"
      ...> })
      ...> changeset.valid?
      true
  """
  @spec signup_changeset(GreenPayments.Users.User.t(), map()) :: Ecto.Changeset.t()
  def signup_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(
      attrs,
      [
        :first_name,
        :last_name,
        :registration_id,
        :email,
        :password,
        :password_confirmation
      ]
    )
    |> validate_required([
      :first_name,
      :registration_id,
      :email,
      :password,
      :password_confirmation
    ])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> CPF.Ecto.Changeset.validate_cpf(:registration_id)
    |> format_registration_id(:registration_id)
    |> unique_constraint(:email)
    |> unique_constraint(:registration_id)
    |> hash_password()
  end

  @doc """
  Receives an user struct and a raw password string.
  It checks if given password matches encrypted_password
  from user struct

  ## Examples

      iex> GreenPayments.Users.User.password_valid?(
      ...>   %GreenPayments.Users.User{encrypted_password: ""},
      ...>   "abcdefg"
      ...> )
      false

      iex> enc = Bcrypt.hash_pwd_salt("abcdefg")
      ...> GreenPayments.Users.User.password_valid?(
      ...>   %GreenPayments.Users.User{encrypted_password: enc},
      ...>   "abcdefg"
      ...> )
      true
  """
  @spec password_valid?(GreenPayments.Users.User.t(), String.t()) :: boolean()
  def password_valid?(%__MODULE__{} = user, password) do
    case Bcrypt.check_pass(user, password) do
      {:ok, _user} -> true
      {:error, _message} -> false
    end
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset

  defp hash_password(%{valid?: true} = changeset) do
    encrypted_password =
      changeset
      |> get_change(:password)
      |> Bcrypt.hash_pwd_salt()

    put_change(changeset, :encrypted_password, encrypted_password)
  end

  defp format_registration_id(%{valid?: false} = changeset, _), do: changeset

  defp format_registration_id(%{valid?: true} = changeset, field) do
    string_id =
      changeset
      |> get_change(field)
      |> CPF.parse!()
      |> to_string()

    put_change(changeset, field, string_id)
  end
end
