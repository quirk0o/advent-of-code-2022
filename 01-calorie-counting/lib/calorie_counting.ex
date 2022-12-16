defmodule CalorieCounting do
  @doc """
  Calculates the maximum number of calories caried by a single Elf

  ## Examples

      iex> CalorieCounting.call([100,200,nil,10])
      {300,10,nil}

      iex> CalorieCounting.call([100,200,nil,10,nil,20,30,nil,1000])
      {1000,300,50}
  """
  @spec call(Enumerable.t()) :: integer()
  def call(inventory) do
    top(inventory, 3)
  end

  defp top(inventory, top) do
    maxes = inventory
    |> Stream.chunk_while(
      0,
      &add_calorie_chunk/2,
      &add_calorie_chunk(nil, &1)
    )
    |> Enum.reduce([], fn
      sum, acc -> [sum | acc] |> Enum.sort(:desc) |> Enum.take(top)
    end)

    maxes = maxes
    |> Enum.concat(List.duplicate(nil, top - length(maxes)))
    |> List.to_tuple()
  end

  defp add_calorie_chunk(elem, sum) when is_nil(elem), do: {:cont, sum, 0}
  defp add_calorie_chunk(elem, sum), do: {:cont, sum + elem}

  defp max(inventory) do
    {last_sum, current_max} = Enum.reduce(inventory, {0, 0}, &add_calories/2)
    max(last_sum, current_max)
  end

  defp add_calories(cal, {sum, current_max}) when is_nil(cal), do: {0, max(sum, current_max)}
  defp add_calories(cal, {sum, current_max}), do: {sum + cal, current_max}
end
