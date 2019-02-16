defmodule Atlas.Repo do
  use Ecto.Repo,
    otp_app: :atlas,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10
end
