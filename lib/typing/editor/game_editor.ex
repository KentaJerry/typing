defmodule Typing.Editor.GameEditor do
  defstruct input_char: "", display_char: ""

  def construct() do
    %__MODULE__{display_char: "HelloWorld"}
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

  def update(%__MODULE__{} = editor, "input_key", %{"key" => key})
    when key not in @exclusion_key do
    %{editor | input_char: editor.input_char <> key}
    # %{"key" => key} = params
    # input_char = editor.input_char
    # char = input_char <> key
    # %{editor | input_char: char}
  end

  def update(%__MODULE__{} = editor, "input_key", _params) do
    editor
  end
end
