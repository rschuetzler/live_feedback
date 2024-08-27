defmodule LiveFeedbackWeb.Plugs.EnsureAdmin do
  import Plug.Conn
  import Phoenix.Controller


  def init(default), do: default

  def call(conn, _opts) do
    user = conn.assigns[:current_user]

    if user && user.is_admin do
      conn
    else
      conn
      |> put_flash(:error, "You must be an admin to access this page.")
      |> redirect(to: get_req_header(conn, "referer"))
      |> halt()
    end
  end
end
