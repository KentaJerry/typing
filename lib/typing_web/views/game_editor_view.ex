defmodule TypingWeb.GameEditorView do
  use TypingWeb, :view

  def trem_display_char(editor) when editor.input_char != "" do
    String.trim(editor.display_char, editor.input_char)
  end

  def trem_display_char(editor), do: editor.display_char

  def get_timer_title(editor) do
    case editor.mode do
      :training -> "経過時間"
      :game -> "残り時間"
      _ ->""
    end
  end
end
