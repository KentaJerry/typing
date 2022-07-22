defmodule Typing.Repo do
  use Ecto.Repo,
    otp_app: :typing,
    adapter: Ecto.Adapters.Postgres
end
