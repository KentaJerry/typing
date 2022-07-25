defmodule Typing.Editor.GameEditor do
  defstruct input_char: "", display_char: ""

  def construct() do
    %__MODULE__{display_char: "HelloWorld"}
  end

  
end
