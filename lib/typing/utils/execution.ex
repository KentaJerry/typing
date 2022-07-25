defmodule Typing.Utils.Execution do
  @file_path ("priv/static/result.exs")

  def execution(expt) do
    File.write(file_path, expr)

    Code.eval_file(@file_path)
  end
end
