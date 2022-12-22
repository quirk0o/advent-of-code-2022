defmodule Rucksacks do
  @doc """
  iex> Rucksacks.badges(["vJrwpWtwJgWrhcsFMMfFFhFp","jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL","PmmdzqPrVvPwwTWBwg","wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn","ttgJtRGJQctTZtZT","CrZsJsPPZsGzwwsLwLmpwMDw"])
  70
  """
  def badges(inputs) do
    inputs
    |> Stream.chunk_every(3)
    |> Stream.map(&find_badge/1)
    |> Stream.map(&item_priority/1)
    |> Enum.sum()
  end

  defp find_badge([fst, snd, thrd]) do
    fst
    |> to_set()
    |> MapSet.intersection(to_set(snd))
    |> MapSet.intersection(to_set(thrd))
    |> MapSet.to_list()
    |> hd()
  end

  @doc """
  iex> Rucksacks.misplaced(["vJrwpWtwJgWrhcsFMMfFFhFp","jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL","PmmdzqPrVvPwwTWBwg","wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn","ttgJtRGJQctTZtZT","CrZsJsPPZsGzwwsLwLmpwMDw"])
  157
  """
  def misplaced(inputs) do
    inputs
    |> Stream.map(&split_compartments/1)
    |> Stream.map(&repeated_item/1)
    |> Stream.map(&item_priority/1)
    |> Enum.sum()
  end

  defp split_compartments(contents) do
    contents |> String.split_at(div(String.length(contents), 2))
  end

  defp repeated_item({left, right}) do
    MapSet.intersection(to_set(left), to_set(right)) |> MapSet.to_list() |> hd()
  end

  defp to_set(items), do: items |> String.to_charlist() |> MapSet.new()

  defp item_priority(item) when item >= 65 and item < 97, do: item - 64 + 26
  defp item_priority(item) when item >= 97, do: item - 96
  defp item_priority(item), do: item
end
