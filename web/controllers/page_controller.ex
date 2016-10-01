defmodule DevNotex.PageController do
  use DevNotex.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
