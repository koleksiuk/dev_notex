defmodule DevNotex.SessionView do
  use DevNotex.Web, :view

  def render("create.json", %{ user: user }) do
    %{ user: user }
  end
end
