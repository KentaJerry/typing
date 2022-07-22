defmodule TypingWeb.PageController do
  use TypingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
