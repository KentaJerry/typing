defmodule TypingWeb.GameEditorLive do
  use Phoenix.LiveView

  def render(assigns), do: TypingWeb.GameEditorView.render(assigns.template, assigns)

    # ~H"""
    # <div>
    # <h1><%= @page_title %></h1>
    # </div>
    # """

  def mount(_params, _session, socket) do
    socket =
      socket
      |>assign(:page_title, "タイピングゲーム")
      |>assign(:template, "main.html")

    {:ok, socket}
  end
end
