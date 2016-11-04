defmodule DevNotex.UserView do
  use DevNotex.Web, :view

  def render("create_error.json", %{changeset: %{changes: user, errors: errors}}) do
    %{
      data: render_one(user, __MODULE__, "user.json"),
      errors: map_errors(errors)
    }
  end

  def render("create.json", %{user: user}) do
    %{
      data: render_one(user, __MODULE__, "user.json")
    }
  end

  def render("user.json", %{user: user}) do
    %{
      user: %{
        id: Map.get(user, :id, nil),
        email: Map.get(user, :email)
      }
    }
  end

  defp map_errors(errors) do
    Enum.map(errors, fn {field, detail} ->
      %{
        field: field,
        message: render_detail(detail)
      }
    end)
  end

  defp render_detail({message, values}) do
    Enum.reduce values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end
  end

  defp render_detail(message), do: message
end
