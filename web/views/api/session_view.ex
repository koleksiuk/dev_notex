defmodule DevNotex.Api.SessionView do
  use DevNotex.Web, :view

  def render("create.json", %{ token: token }) do
    %{
      data: render_one(token, __MODULE__, "token.json")
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

  def render("delete.json", _assigns) do
    %{
      token: nil
    }
  end
end
