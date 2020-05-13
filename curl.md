- ### Create an user and account:

  ```
    curl -X POST \
    {url}/api/v1/signup \
    -H 'Content-Type: application/json' \
    -H 'cache-control: no-cache' \
    -d '{
      "first_name": "Marcelo",
      "last_name": "Jasek",
      "email": "marcelo.jasek@stone.com",
      "registration_id": "033.238.290-77",
      "password": "RD3U3SEAKgzbm9Gu",
      "password_confirmation": "RD3U3SEAKgzbm9Gu"
    }'
  ```

- ### Login to an account:

  ```
    curl -X POST \
    {url}/api/v1/login \
    -H 'Content-Type: application/json' \
    -H 'cache-control: no-cache' \
    -d '{
      "email": "marcelo.jasek@stone.com",
      "password": "RD3U3SEAKgzbm9Gu"
    }'
  ```

- ### Account withdraw

  ```
    curl -X POST \
    {url}/api/v1/accounts/{id}/transactions/withdraw \
    -H 'Authorization: Bearer JWT-TOKEN-HERE' \
    -H 'Content-Type: application/json' \
    -H 'cache-control: no-cache' \
    -d '{
    "amount": 0
    }'
  ```

- ### Transfers between accounts

  > Must have two users/accounts for testing, since cannot transfer to the same account

  ```
    curl -X POST \
    {url}/api/v1/accounts/{id}/transactions/transfer/{id} \
    -H 'Authorization: Bearer JWT-TOKEN-HERE' \
    -H 'Content-Type: application/json' \
    -H 'cache-control: no-cache' \
    -d '{
    "amount": 0
    }'
  ```

- ### Retrieving an account history:

  ```
    curl -X GET \
    {url}/api/v1/accounts/{id}/history \
    -H 'Authorization: Bearer JWT-TOKEN-HERE' \
    -H 'cache-control: no-cache'
  ```
