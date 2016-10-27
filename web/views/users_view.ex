defmodule DevNotex.UsersView do
  use DevNotex.Web, :view

  def render("create_error.json", %{changeset: %{changes: user, errors: errors}}) do
    %{
      user: %{
        email: user.email
      },
      errors: map_errors(errors)
    }
  end

  def render("create.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email
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
