defmodule CalorieCounting.Cli do
  def main(args) do
    parsed = OptionParser.parse(args, strict: [])

    with {_, [input_file], _} <- parsed,
         true <- File.regular?(input_file) do
      answer = input_file
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&parse_line/1)
      |> CalorieCounting.call()

      IO.puts("The answer is:")
      IO.inspect(answer)
    else
      e ->
        IO.inspect(e)
        System.halt(1)
    end
  end

  defp parse_line(""), do: nil
  defp parse_line(str), do: String.to_integer(str)
end
