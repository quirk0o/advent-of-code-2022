defmodule RockPaperScissors.Cli do
  def main(args) do
    parsed = OptionParser.parse(args, strict: [])

    with {_, [input_file], _} <- parsed,
         true <- File.regular?(input_file) do
      answer = input_file
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&parse_line/1)
      |> RockPaperScissors.call()

      IO.puts("The answer is:")
      IO.inspect(answer)
    else
      false ->
        IO.puts("File does not exist")
        System.halt(1)
      e ->
        IO.inspect(e)
        System.halt(1)
    end
  end

  defp parse_line(line) do
    line
    |> String.split("\s")
    |> Enum.map(&map_input/1)
    |> List.to_tuple()
  end

  defp map_input("A"), do: :rock
  defp map_input("B"), do: :paper
  defp map_input("C"), do: :scissors
  defp map_input("X"), do: :lose
  defp map_input("Y"), do: :draw
  defp map_input("Z"), do: :win
end
