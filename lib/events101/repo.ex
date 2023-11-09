defmodule Events101.Repo do
  use Ecto.Repo,
    otp_app: :events101,
    adapter: Ecto.Adapters.Postgres
end
