defmodule TypingWeb.GameEditorLive do
  use Phoenix.LiveView
  alias Typing.Editor.GameEditor

  def render(assigns), do: TypingWeb.GameEditorView.render(assigns.template, assigns)

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:editor, GameEditor.construct())
      |> assign(:page_title, "タイピングゲーム")
      |> assign(:template, "main.html")

      if connected?(socket) do
      :timer.send_interval(1000, "timer")
      end

    {:ok, socket}
  end

  def handle_info("timer", socket) do
    socket =
      update(socket, :editor, fn editor ->
        GameEditor.update(editor, "timer")
      end)

    {:noreply, socket}
  end

  # event = "select_mode" の時だけ↓を呼ぶ
  def handle_event("toggle_" <> event = "resurt_mode", params, socket) do
    socket =
      update(socket, :editor, fn editor ->
        GameEditor.update(editor, event, params)
      end)
      if connected?(socket) and socket.assigns.editor.mode in [:training, :game] do
        :timer.send_interval(1000, "timer")
      end
    {:noreply, socket}
    end

  # event = "select_mode" 以外の時に↓を呼ぶ
  def handle_event("toggle_" <> event, params, socket) do
    socket =
      update(socket, :editor, fn editor ->
        GameEditor.update(editor, event, params)
      end)

      {:noreply, socket}
  end
end
