defmodule GreenPayments.Users.RepositoryTest do
  use GreenPayments.DataCase
  alias GreenPayments.Users.{Repository, User}

  doctest GreenPayments.Users.Repository

  describe "users repository signup/1" do
    @pwd Faker.String.base64(8)

    @valid_parameters %{
      first_name: Faker.Name.first_name(),
      last_name: Faker.Name.last_name(),
      registration_id: to_string(CPF.generate()),
      email: Faker.Internet.email(),
      password: @pwd,
      password_confirmation: @pwd,
      agency: Faker.Util.pick(1..99)
    }

    test "with valid data" do
      assert {:ok, user} = Repository.signup(@valid_parameters)

      assert user.first_name == @valid_parameters.first_name
      assert user.last_name == @valid_parameters.last_name
      assert user.registration_id == @valid_parameters.registration_id
      assert user.email == @valid_parameters.email
      assert User.password_valid?(user, @pwd)
    end

    test "with duplicated email" do
      assert {:ok, user} = Repository.signup(@valid_parameters)

      repeated_email_attrs =
        Map.put(@valid_parameters, :registration_id, to_string(CPF.generate()))

      assert {:error, changeset} = Repository.signup(repeated_email_attrs)

      assert !changeset.valid?
      assert Keyword.keys(changeset.errors) == [:email]

      error = Keyword.fetch!(changeset.errors, :email)
      assert elem(error, 0) == "has already been taken"
    end

    test "with duplicated registration_id" do
      assert {:ok, user} = Repository.signup(@valid_parameters)

      repeated_reg_attrs = Map.put(@valid_parameters, :email, Faker.Internet.email())
      assert {:error, changeset} = Repository.signup(repeated_reg_attrs)

      assert !changeset.valid?
      assert Keyword.keys(changeset.errors) == [:registration_id]

      error = Keyword.fetch!(changeset.errors, :registration_id)
      assert elem(error, 0) == "has already been taken"
    end
  end

  describe "users repository signup_with_account/2" do
    test "with valid data" do
      agency = Faker.Util.pick(1..99)

      assert {:ok, {user, account}} = Repository.signup_with_account(@valid_parameters, agency)

      assert user.first_name == @valid_parameters.first_name
      assert user.last_name == @valid_parameters.last_name
      assert user.registration_id == @valid_parameters.registration_id
      assert user.email == @valid_parameters.email
      assert User.password_valid?(user, @pwd)

      # should create an account for this user
      assert account.agency == agency
      assert account.user_id == user.id
    end

    test "with error in user" do
      assert {:ok, user} = Repository.signup(@valid_parameters)

      assert {:error, {changeset, nil}} = Repository.signup_with_account(@valid_parameters, 1)

      assert !changeset.valid?
      assert Keyword.keys(changeset.errors) == [:registration_id]
      error = Keyword.fetch!(changeset.errors, :registration_id)
      assert elem(error, 0) == "has already been taken"
    end

    test "with error in agency" do
      assert {:error, {nil, error}} = Repository.signup_with_account(@valid_parameters, "abc")

      assert error == "invalid agency number"
    end
  end

  describe "users repository login/2" do
    test "with valid attributes" do
      assert {:ok, registered_user} = Repository.signup(@valid_parameters)
      assert {:ok, user} = Repository.login(registered_user.email, @pwd)

      assert user.id == registered_user.id
      assert user.registration_id == registered_user.registration_id
    end

    test "with invalid password" do
      assert {:ok, registered_user} = Repository.signup(@valid_parameters)

      assert {:error, "invalid user and password"} =
               Repository.login(registered_user.email, Faker.String.base64(6))
    end

    test "with nil password" do
      assert {:ok, registered_user} = Repository.signup(@valid_parameters)

      assert {:error, "invalid user and password"} = Repository.login(registered_user.email, nil)
    end

    test "with nil email" do
      assert {:error, "invalid user and password"} = Repository.login(nil, @pwd)
    end

    test "with nonexistent email" do
      assert {:ok, registered_user} = Repository.signup(@valid_parameters)

      assert {:error, "invalid user and password"} =
               Repository.login(Faker.Internet.email(), @pwd)
    end
  end

  describe "users repository find_user_by_email/1" do
    test "with existent email" do
      assert {:ok, registered_user} = Repository.signup(@valid_parameters)
      user = Repository.find_user_by_email(registered_user.email)

      assert user.email == registered_user.email
    end

    test "with invalid email" do
      user = Repository.find_user_by_email(Faker.Internet.email())
      assert user == nil
    end
  end
end
