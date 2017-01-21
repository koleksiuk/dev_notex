defmodule DevNotex.Api.UserView do
  use JSONAPI.View

  def render("show.json", %{user: user, conn: conn, params: params}) do
    __MODULE__.show(user, conn, params)
  end

  def fields do
    [:id, :email]
  end
  def type(), do: "user"
end
