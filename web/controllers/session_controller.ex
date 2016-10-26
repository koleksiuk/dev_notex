defmodule DevNotex.SessionController do
  use DevNotex.Web, :controller

  def create(conn, _params) do
    render conn, "create.json", user: true
  end

  def delete(conn, _params) do
    render conn, "delete.json", user: false
  end
end
