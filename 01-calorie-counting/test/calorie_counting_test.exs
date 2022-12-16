defmodule CalorieCountingTest do
  use ExUnit.Case
  use PropCheck
  doctest CalorieCounting

  property "finds largest sum" do
    forall items <- inventory() do
      CalorieCounting.max(items) == max_sum(items)
    end
  end

  property "finds largest 3 sums" do
    forall items <- inventory() do
      CalorieCounting.call(items) == top_3(items)
    end
  end

  defp inventory() do
    non_empty(
      list(
        frequency([
          {1, nil},
          {6, nat()}
        ])
      )
    )
  end

  defp max_sum(items) do
    items
    |> Enum.chunk_by(&is_nil/1)
    |> Enum.reject(&is_nil(hd(&1)))
    |> Enum.map(&Enum.sum/1)
    |> case do
      [] -> 0
      xs -> Enum.max(xs)
    end
  end

  defp top_3(items) do
    items
    |> Enum.chunk_by(&is_nil/1)
    |> Enum.reject(&is_nil(hd(&1)))
    |> Enum.map(&Enum.sum/1)
    |> case do
      [] -> 0
      xs -> Enum.sort(xs, :desc) |> Enum.take(3)
    end
  end
end
