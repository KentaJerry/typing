defmodule TypingWeb.GameEditorLive do
  use Phoenix.LiveView
  alias Typing.Editor.GameEditor

  def render(assigns), do: TypingWeb.GameEditorView.render(assigns.template, assigns)

  def mount(params, _session, socket) do
    socket =
      socket
      |>assign(:editor, GameEditor.construct())
      |>assign(:page_title, "タイピングゲーム")
      |>assign(:template, "main.html")

    {:ok, socket}
  end

  def handle_event("toggle_" <> key, params, socket) do
   socket =
    update(socket, :editor, fn editor ->
      GameEditor.update(editor, key, params)
    end)

    {:noreply, socket}
  end
end
