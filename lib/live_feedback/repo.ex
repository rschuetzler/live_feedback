defmodule LiveFeedback.Repo do
  use Ecto.Repo,
    otp_app: :live_feedback,
    adapter: Ecto.Adapters.Postgres
end
