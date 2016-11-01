defmodule DevNotex.SessionView do
  use DevNotex.Web, :view

  def render("create.json", %{ token: token }) do
    %{
      data: render_one(token, DevNotex.SessionView, "token.json")
    }
  end

  def render("token.json", %{ session: auth_token }) do
    %{
      token: auth_token.token
    }
  end

  def render("error.json", _assigns) do
    %{errors: "failed to authenticate"}
  end
end
