defmodule LiveFeedbackWeb.Plugs.AssignAnonymousId do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    case get_session(conn, :anonymous_id) do
      nil ->
        anonymous_id = UUID.uuid4()
        put_session(conn, :anonymous_id, anonymous_id)
      _anonymous_id ->
        conn
    end
  end
end
