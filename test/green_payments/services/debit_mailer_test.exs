defmodule GreenPayments.Services.DebitMailerTest do
  use GreenPayments.DataCase

  doctest GreenPayments.Services.DebitMailer

  import Mock

  describe "debit mailer service send_debit_email/3" do
    test "generate message parts" do
      {:ok, user} =
        GreenPayments.Users.Repository.signup(%{
          email: "marcelo@gmail.com",
          first_name: "Marcelo",
          last_name: "Jasek",
          password: "RD3U3SEAKgzbm9Gu",
          password_confirmation: "RD3U3SEAKgzbm9Gu",
          registration_id: to_string(CPF.generate()),
          agency: Faker.Util.pick(1..99)
        })

      {:ok, account} =
        GreenPayments.Accounts.Repository.create_account(
          user,
          1
        )

      now = NaiveDateTime.utc_now()
      date_now = NaiveDateTime.to_iso8601(now)

      with_mocks([{NaiveDateTime, [], [to_iso8601: fn _ -> date_now end, utc_now: fn -> now end]}]) do
        # there is no transaction, but it simulates
        message = GreenPayments.Services.DebitMailer.send_debit_email(user, account, 100_000)

        assert message == """
               From: "Marcelo Jasek" <marcelo@stone.com.br>
               To: Marcelo Jasek <marcelo@gmail.com>
               Cc: contact@stone.com.br
               Date: #{date_now}
               Subject: There was a debit on your account

               Hello Marcelo.
               This is just a reminder that R$1.000,00 was debited from your account.

               Account:
               Agency: #{account.agency}
               Number: #{account.number}

               Your business's best account,
               Stone
               """
      end
    end
  end
end
