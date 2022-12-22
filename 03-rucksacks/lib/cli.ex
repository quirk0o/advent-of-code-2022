defmodule Rucksacks.Cli do
  def main(args) do
    parsed = OptionParser.parse(args, strict: [])

    with {_, [input_file], _} <- parsed,
         true <- File.regular?(input_file) do
      answer = input_file
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Rucksacks.badges()

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
end
