# JobBoard

An Elixir Job Board web app. Uses Phoenix LiveView, DaisyUI, and Ecto.

## Setup

```bash
$ git clone git@github.com:ZaneH-YT/job_board.git
$ cd job_board
$ mix deps.get
$ mix ecto.create # check ./config/dev.exs
$ mix ecto.migrate
```

## Seed Data

This will populate the database with dummy (seed) data.

```bash
$ mix run ./priv/repo/seeds.exs
```

## Run

```bash
$ iex -S mix phx.server # or
$ mix phx.server
```

- Open browser to `localhost:4000`