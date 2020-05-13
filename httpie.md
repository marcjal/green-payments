- ### Create an user and account:

  ```
    echo '{
        "first_name": "Marcelo",
        "last_name": "Jasek",
        "email": "marcelo.jasek@stone.com",
        "registration_id": "033.238.290-77",
        "password": "RD3U3SEAKgzbm9Gu",
        "password_confirmation": "RD3U3SEAKgzbm9Gu"
    }' | http --json POST '{url}/api/v1/signup' 'cache-control:no-cache'
  ```

  - ### Login to an account:

  ```
    echo '{
        "email": "marcelo.jasek@stone.com",
        "password": "RD3U3SEAKgzbm9Gu"
        }' | http --json POST '{url}/api/v1/login' 'cache-control:no-cache'
  ```

- ### Account withdraw

  ```
    echo '{
        "amount": 0
        }' | http --json POST '{url}/api/v1/accounts/{id}/transactions/withdraw' 'Authorization:Bearer JWT-TOKEN-HERE' 'cache-control:no-cache'
  ```

- ### Transfers between accounts

  > Must have two users/accounts for testing, since cannot transfer to the same account

  ```
    echo '{
        "amount": 0
        }' | http --json POST '{url}/api/v1/accounts/{id}/transactions/transfer/{id}' 'Authorization:Bearer JWT-TOKEN-HERE' 'cache-control:no-cache'
  ```

- ### Retrieving an account history:

  ```
    http GET '{url}/api/v1/accounts/{id}/history' 'Authorization:Bearer JWT-TOKEN-HERE' 'cache-control:no-cache'
  ```