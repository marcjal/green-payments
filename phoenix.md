# Installing Phoenix on Windows

First, make sure you have Elixir installed -- which you should if you are following this course from the start.

Then, let's go ahead and set up the requirements for Phoenix.

## Install Postgres

First, install Postgres by downloading it from here:

https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

The latest version is recommended. Choose your Windows version (32-bit or 64-bit). Download and install using the wizard.

**When asked for the password, just set it to "postgres"**

## Install Node.js

Download and install Node's Long Term Support (LTS) version from here: https://nodejs.org/en/download/

Install using the wizard. Default work fine.

## Setting Up Phoenix

Open the command prompt and issue the following commands.

```bash
mix local.hex
mix local.rebar --force

mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

mkdir elixir-phoenix
cd elixir-phoenix
mix phx.new hello

cd hello
mix deps.get
mix ecto.create

cd assets
npm install
cd ..

mix phx.server
```

Then, open your browser to http://localhost:4000/ to see the Phoenix welcome page.

# Installing Phoenix on Ubuntu

First, make sure you have Elixir installed -- which you should if you are following this course from the start.

Then, let's go ahead and set up the requirements for Phoenix.

```bash
sudo apt install curl -y

# install postgres on ubuntu with apt
sudo apt install postgresql postgresql-contrib
service postgresql  status

sudo -i -u postgres   # enter postgres
psql postgres
\password postgres    # Set password to 'postgres'
\q                    # back to bash


# Install Node (needed for assets)
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
export NVM_DIR="$HOME/.nvm" ; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# This loads nvm ... also put in bash_profile

nvm install --lts
nvm use --lts

# inotify-tools for live reload
sudo apt install inotify-tools


# Lets get Phoenix
cd ~

mix local.hex
mix local.rebar --force
mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

mkdir elixir-phoenix
cd elixir-phoenix
mix phx.new hello

cd hello
mix deps.get
mix ecto.create

cd assets
npm install
cd ..

mix phx.server
```

Then, open your browser to http://localhost:4000/ to see the Phoenix welcome page.

# Installing Phoenix on Mac

First, make sure you have Elixir installed -- which you should if you are following this course from the start.

Then, let's go ahead and set up the requirements for Phoenix.

## Install Postgres

Since we have already installed homebrew before, let's just that to set up Postgres.

```bash
brew install postgres
brew services start postgresql

# We also need to create the postgres user
# since it's not automatically created by brew
createuser -d postgres

# In case of connection errors, set the password
# psql -U postgres
# ALTER USER postgres PASSWORD 'postgres';
```

## Install Node.js

This can be done easily through NVM

```bash
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
export NVM_DIR="$HOME/.nvm" ; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# This loads nvm ... also put in bash_profile

nvm install --lts
nvm use --lts
```

## Setting Up Phoenix

Open your favorite terminal and issue the following commands.

```bash
cd ~
mix local.hex
mix local.rebar --force

mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

mkdir elixir-phoenix
cd elixir-phoenix
mix phx.new hello

cd hello
mix deps.get
mix ecto.create

cd assets
npm install
cd ..

mix phx.server
```

Then, open your browser to http://localhost:4000/ to see the Phoenix welcome page.
