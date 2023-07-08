defmodule JobBoard.Repo do
  use Ecto.Repo,
    otp_app: :job_board,
    adapter: Ecto.Adapters.Postgres
end
