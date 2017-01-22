defmodule DevNotex.Api.NoteView do
  use JSONAPI.View

  def render("index.json", %{ notes: notes, conn: conn, params: params }) do
    __MODULE__.index(notes, conn, params)
  end

  def fields do
    [:id, :title, :content]
  end
  def type(), do: "note"
end
