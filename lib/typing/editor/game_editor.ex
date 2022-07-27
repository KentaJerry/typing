defmodule Typing.Editor.GameEditor do
  import Typing.Utils.KeysDecision
  alias Typing.Utils.Execution

  defstruct input_char: "",
            display_char: "",
            char_count: 0,
            now_char_count: 0,
            failure_count: 0,
            game_status: 0,
            char_list: [],
            clear_count: 0,
            result: nil,
            mode: :select,
            timer: 0,
            input_time: 0,
            failure_count: 0,
            results: []

  # @spec construct :: %Typing.Editor.GameEditor{
  #         char_count: non_neg_integer,
  #         char_list: [<<_::64, _::_*8>>, ...],
  #         clear_count: 0,
  #         display_char: <<_::64, _::_*8>>,
  #         failure_count: 0,
  #         game_status: 1,
  #         input_char: <<>>,
  #         mode: :select,
  #         now_char_count: 0,
  #         result: nil
  #       }
  def construct() do
    char_list = [
      "Enum.map([1, 2, 3], fn a -> a * 2 end)",
      "Enum.shuffle([1, 2, 3])",
      "Enum.reverse([1, 2, 3])",
      "Map.put(%{a: \"a\", b: \"b\", c: \"c\"}, :d, \"b\")",
      "Enum.map([1, 2, 3], fn a -> a * 2 end) |> Enum.shuffle()"
    ]

    display_char = hd(char_list)

    %__MODULE__{
      display_char: display_char,
      char_count: String.length(display_char),
      game_status: 1,
      char_list: char_list
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
  )

  def update(%__MODULE__{display_char: char, now_char_count: count} = editor, "input_key", %{
        "key" => key
      })
      when key not in @exclusion_key and key_check(char, count, key) and editor.game_status == 1 do
    cond do
      editor.now_char_count == editor.char_count - 1 ->
        display_result(editor, key)

      true ->
        %{
          editor
          | input_char: editor.input_char <> key,
            now_char_count: editor.now_char_count + 1
        }
    end
  end

  def update(%__MODULE__{} = editor, "input_key", %{"key" => key})
      when key not in @exclusion_key and editor.game_status == 1 do
    %{editor | failure_count: editor.failure_count + 1}
  end

  def update(%__MODULE__{} = editor, "input_key", %{"key" => key})
      when key == "Enter" and editor.game_status == 2 do
        next_char(editor, key)
      end

  def update(%__MODULE__{} = editor, "select_mode", %{"mode" =>mode})
      when mode in ["training", "select"] do
        mode = String.to_atom(mode)
        %{editor | mode: mode}
      end

  def update(%__MODULE__{} = editor, "select_mode", %{"mode" => "game"}) do
    %{editor | mode: :game, timer: 60, game_status: 1}
  end

  def update(%__MODULE__{} = editor, "select_mode", %{"mode" => mode})
    when mode in ["training", "result"] do
      timer =
        if mode == "result", do: editor.timer, else: 0
        %{editor | mode: String.to_atom(mode), timer: 0, game_status: 1}
  end

  def update(%__MODULE__{} = editor, "select_mode", _params) do
    char_list =
      [
        "Enum.map([1, 2, 3], fn a -> a * 2 end)",
        "Enum.shuffle([1, 2, 3])",
        "Enum.map([1, 2, 3])"
      ]

      %{
        editor
        | mode: :select,
          failure_counts: 0,
          failure_count: 0,
          game_status: 0,
          clear_count: 0,
          timer: 0,
          results: [],
          display_char: hd(char_list),
          char_list: char_list,
          char_count: String.length(hd(char_list)),
          input_char: "",
          now_char_count: 0,
          input_time: 0
        }
  end

  def update(%__MODULE__{} = editor, "select_mode", %{"mode" => "training"}) do
    %{editor | mode: :training, timer: 0}
  end

  def update(%__MODULE__{} = editor, "select_mode", _params) do
    %{editor | mode: :select}
  end

  def update(%__MODULE__{} = editor, "timer")
      when editor.mode == :training and editor.game_status == 1 do
        %{editor | timer: editor.timer + 1, input_time: editor.input_time + 1}
      end

  def update(%__MODULE__{} = editor, "timer")
    when editor.mode == :game and editor.game_status == 1 do
      %{editor | timer: editor.timer - 1, input_time: editor.input_time + 1}
    end

  def update(%__MODULE__{} = editor, "timer")
    when editor.mode == :training and editor.game_status == 1 and editor.timer <= 0 do
      %{
        editor
        | display_char: "終了",
          game_status: 3,
          result: nil
        }
      end

      def update(%__MODULE__{} = editor, "timer")

    when editor.mode == :training and editor.game_status == 1 and editor.timer <= 0 do
      %{
        editor
        | display_char: "終了",
          game_status: 3,
          result: nil,
          failure_count: 0
        }
      end

  def update(%__MODULE__{} = editor, "timer"), do: editor

  def update(%__MODULE__{} = editor, "input_key", _params), do: editor

  defp next_char(editor, key) do
    char_list = List.delete(editor.char_list, editor.display_char)

    char_list =
      if length(char_list) == 0 and editor.mode == :game do
        list =
        [
          "Enum.map([1, 2, 3])",
          "Enum.map([1, 2, 3], fn a -> a * 2 end)",
          "Enum.shuffle([1, 2, 3])"
        ]


    Enum.shuffle(list)
  else
    char_list
  end

  timer =
    if editor.mode == :game, do: editor.timer + 2, else: editor.timer

    case length(char_list) do
      0 ->
        %{
          editor
          | char_list: char_list,
            display_char: "クリア",
            input_char: editor.input_char,
            game_status: 0,
            clear_count: editor.clear_count + 1,
            result: nil
        }

      _num ->
        display_char = hd(char_list)

        %{
          editor
          | char_list: char_list,
            display_char: display_char,
            input_char: "",
            char_count: String.length(display_char),
            now_char_count: 0,
            clear_count: editor.clear_count + 1,
            game_status: 3,
            result: nil,
            timer: timer,
            input_time: 0
        }
      end
  end


  defp display_result(editor, key) do
    {result, _} = Execution.execution(editor.display_char)

    results =
      %{
        display_char: editor.display_char,
        time: editor.input_time,
        result: result,
        failure_count: editor.failure_count
      }

    %{
      editor
      | result: result,
        game_status: 2,
        input_char: editor.input_char <> key,
        clear_count: editor.clear_count + 1,
        results: List.insert_at(editor.results, -1, results)
    }
  end

end
