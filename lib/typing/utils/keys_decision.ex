defmodule Typing.Utils.KeysDecision do
  defmacro key_check(char, count, key) do
    quote do
      binary_part(unquote(char), unquote(count), 1) == unquote(key)
    end
  end
end
