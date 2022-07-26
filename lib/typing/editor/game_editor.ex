defmodule Typing.Editor.GameEditor do
  import Typing.Utils.KeysDecision
  alias Typing.Utils.Excution

  defstruct input_char: "", display_char: "", char_list: [],
  char_count: 0, now_char_count: 0, failure_count: 0, game_status: 0, clear_count: 0, result: "any"

  def construct() do
    char_list = [
      "Enum.map([1, 2, 3], fn a -> a * 2 end)",
      "Enum.shuffle([1, 2, 3])",
      "Enum.reverse([1, 2, 3])",
      "Map.put(%{a: \"a\", b: \"b\", c: \"c\"}, :d, \"b\")",
      "Enum.map([1, 2, 3], fn a -> a * 2 end)"
    ]
    display_char = hd(char_list)

    %__MODULE__{
      display_char: display_char,
      char_count: String.length(display_char),
      game_status: 1,
      char_list: char_list,
    }
  end

  @exclusion_key ~W(
    Tab
    Control
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
    Shift
  )

  def update(%__MODULE__{display_char: char, now_char_count: count, clear_count: clear_count} = editor, "input_key", %{"key" => key})
  when key not in @exclusion_key and key_check(char, count, key) and editor.game_status == 1 do
    cond do
      editor.now_char_count == editor.char_count - 1 ->
        display_result(editor, key)
        # next_char(editor, key)
        editor.now_char_count < editor.char_count ->
          %{editor| now_char_count: editor.now_char_count + 1, input_char: editor.input_char <> key}
        end
      end

      def update(%__MODULE__{} = editor, "input_key", %{"key" => key})
      when key not in @exclusion_key and editor.game_status == 1 do
        %{editor|failure_count: editor.failure_count + 1}
      end

      def update(%__MODULE__{} = editor, "input_key", _params), do: editor


  defp next_char(editor, key) do
    char_list = List.delete(editor.char_list, editor.display_char)

    case length(char_list) do
      0 -> %{
        editor|
        display_char: "クリア！！",
        char_list: char_list,
        game_status: 0,
        clear_count: editor.clear_count + 1,
        input_char: editor.input_char <> key
      }

      _num -> display_char = hd(char_list)
      %{
        editor|
        char_list: char_list,
        display_char: display_char,
        game_status: 1,
        now_char_count: 0,
        input_char: "",
        clear_count: editor.clear_count + 1,
        char_count: String.length(display_char)
      }
    end
  end

  defp display_result(editor, key) do
    {result, _} = Excution.exection(editor.display_cha)

    %{
      editor
      | result: result,
      input_char: editor.input_char <> key,
      clear_count: editor.clear_count + 1
    }
  end

end
