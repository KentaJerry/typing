defmodule TypingWeb.GameEditorView do
  use TypingWeb, :view

  def trem_display_char(editor) when editor.input_char != "" do
    String.trim(editor.display_char, editor.input_char)
  end

  def trem_display_char(editor), do: editor.display_char
end
