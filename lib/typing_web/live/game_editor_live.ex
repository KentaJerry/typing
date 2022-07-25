defmodule TypingWeb.GameEditorLive do
  use Phoenix.LiveView
  alias Typing.Editor.GameEditor

  def render(assigns), do: TypingWeb.GameEditorView.render(assigns.template, assigns)

  def mount(_params, _session, socket) do
    socket =
      socket
      |>assign(:editor, GameEditor.construct())
      |>assign(:page_title, "タイピングゲーム")
      |>assign(:template, "main.html")

    {:ok, socket}
  end

  def handle_event("toggle_input_key", params, socket) do
   socket =
    update(socket, :input_key, fn input_key ->
      key =Map.get(params, "key", "")
    end)
    {:noreply, socket}
  end
end
