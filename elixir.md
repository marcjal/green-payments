# Set Up Elixir

## Windows

Download the installer from https://repo.hex.pm/elixir-websetup.exe

Install it using the wizard. All the default should work fine.

It might ask you to install some .Net redistributables. Just go ahead and click ok on that as well.

## Ubuntu

Let's first set up Elixir.

```bash

# Set up the repository

wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb

sudo apt update
sudo apt install esl-erlang -y
sudo apt install elixir -y
```

## MacOS

If you don't already have homebrew (https://brew.sh), install that:

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Then, go ahead and install elixir using that:

```bash
brew install elixir
```

## Running Elixir

Now that we have elixir set up, let's make sure it's working correctly.

```bash
# Getting started with Elixir.
# Just type:
# iex
# to enter the interactive shell
```

And here's the hello world for it!

```elixir
IO.puts "Hello World!"
```
