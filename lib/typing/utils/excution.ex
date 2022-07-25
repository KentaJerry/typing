defmodule Typing.Utils.Excution do
  @file_path("priv/static/result/exs")

  def excution(expr) do
    File.write(@file_path, expr)

    Code.eval_file(@file_path)
  end
end
