# Green Payments

This project implements a bank system where users can transact money.

### Project setup

If you don't have installed elixir and phoenix. Follow the next links to see how to proceed: [elixir](elixir.md) & [phoenix](phoenix.md)

For those that used asdf I added the .tool-versions file with a pre-defined elixir version to use.

To start your Phoenix server:

  * Run docker-compose up
  * Create and migrate your database with `mix ecto.create`
  * Create and migrate your database for test case `MIX_ENV=test mix ecto.create`
  * Start Phoenix endpoint with `mix phx.server`

  To keep code legible, `mix` comes with a built-in formatter. It is used during development and on CI to check if the developer ran it.
    * mix format
    * mix format --check-formatted --dry-run
  
  To check code consistency, this project uses [Credo](https://github.com/rrrene/credo) as a static code analysis tool and is also used on CI. Credo can be run by the following command.
    * mix credo

  For checking tests coverage, the library `excoveralls` is used. It can be called by running `mix coveralls` (results on console) and `mix coveralls.html` to generate a html page holding results and code points in `./cover/excoveralls.html`.

  Some files were ignored from testing, like phoenix-generated functions and test support functions. The are listed in `coveralls.json`, inside the key `skip_files`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


### About project configuration

This project follow some recomendation José Valim and an awesome team of developers [releases](https://github.com/phoenixframework/phoenix/blob/master/guides/deployment/releases.md)

## How to use the API

Here are the examples for calling the API

|   VERBS    |   Endpoints                                                             |
|------------|:-----------------------------------------------------------------------:|
|POST        | /api/v1/signup                                                          |
|POST        | /api/v1/login                                                           |
|GET         | /api/v1/accounts/:account_id/history                                    |
|POST        | /api/v1/accounts/:account_id/transactions/withdraw                      |
|POST        | /api/v1/accounts/:account_id/transactions/transfer/:credit_account_id   |

- ### Create an user and account:

```
{
   "account":{
      "id":3,
      "agency":1,
      "number":3,
      "balance":100000
   },
   "auth":"JWT-TOKEN",
   "error":null,
   "user":{
      "id":1,
      "first_name":"Marcelo",
      "last_name":"Jasek",
      "registration_id":"03323829077",
      "email":"marcelo.jasek@stone.com"
   }
}
```

- ### Login to an account:

```
{
   "auth":"JWT-TOKEN",
   "error":null,
   "user":{
      "id":1,
      "first_name":"Marcelo",
      "last_name":"Jasek",
      "registration_id":"03323829077",
      "email":"marcelo.jasek@stone.com"
   }
}
```

- ### Account withdraw

```
{
   "account":{
      "id":1,
      "agency":1,
      "number":1,
      "balance":100000
   },
   "error":false
}
```

- ### Transfers between accounts

```
{
  "credit_account": {
      "id": 2,
      "agency": 1,
      "number": 2,
      "balance": 100343
  },
  "debit_account": {
      "id": 1,
      "agency": 1,
      "number": 1,
      "balance": 99602
  },
  "error": {
      "credit": null,
      "debit": null
  }
}
```

- ### Retrieving an account history:

```
{
   "error":false,
   "history":{
      "items":[
         {
            "type":"credit",
            "amount":100000
         }
      ],
      "total_credit":100000,
      "total_debit":0
   }
}
```
