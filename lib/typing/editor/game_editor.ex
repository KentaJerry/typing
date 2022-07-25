defmodule Typing.Editor.GameEditor do
  import Typing.Utils.KeysDecision
  defstruct input_char: "", display_char: "", char_count: 0, now_char_count: 0, failure_count: 0

  def construct() do
    %__MODULE__{
      display_char: "HelloWorld",
      char_count: String.length("HelloWorld")
  }
  end

  @exclusion_key ~w(
    Tab
    Control
    Shift
    CapsLock
    Alt
    Meta
    Eisu
    KanjiMode
    Backspace
    Enter
    Escape
    ArrowLeft
    ArrowRight
    ArrowUp
    ArrowDown
  ) ++ [" "]

  def update(%__MODULE__{display_char: char, now_char_count: count} = editor, "input_key", %{"key" => key})
    when key not in @exclusion_key and key_check(char, count, key) do
      cond do
        editor.now_char_count == editor.char_count - 1  ->
        %{editor | display_char: "クリア", input_char: editor.input_char <> key}
        true ->
        %{editor | input_char: editor.input_char <> key, now_char_count: editor.now_char_count + 1}
      end
  end

  def update(%__MODULE__{} = editor, "input_key", %{"key" => key})
    when key not in @exclusion_key do
    %{editor | failure_count: editor.failure_count + 1}
  end

  def update(%__MODULE__{} =editor, "input_key", _params), do: editor

end
