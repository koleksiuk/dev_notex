defmodule DevNotex.Api.NoteView do
  use JSONAPI.View

  def render("index.json", %{ notes: notes, conn: conn, params: params }) do
    index(notes, conn, params)
  end

  def render("show.json", %{ note: note, conn: conn, params: params }) do
    show(note, conn, params)
  end

  def fields do
    [:title, :content]
  end
  def type(), do: "note"
end
