defmodule DevNotex.UsersView do
  use DevNotex.Web, :view

  def render("create.json", %{ user: user }) do
    %{
      id: user.id,
      email: user.email
    }
  end
end
