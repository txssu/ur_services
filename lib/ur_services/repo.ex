defmodule UrServices.Repo do
  use Ecto.Repo,
    otp_app: :ur_services,
    adapter: Ecto.Adapters.Postgres
end
