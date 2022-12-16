defmodule RockPaperScissors do
  @type t :: :rock | :paper | :scissors

  def call(guide) do
    guide
    |> Stream.map(fn {player, strategy} ->
      shape_score(choose_shape({player, strategy})) + outcome_score(strategy)
    end)
    |> Enum.sum()
  end

  @spec choose_shape({__MODULE__.t(), :draw | :lose | :win}) :: __MODULE__.t()
  def choose_shape({player, :win}), do: win(player)
  def choose_shape({player, :lose}), do: lose(player)
  def choose_shape({player, :draw}), do: player

  defp win(:rock), do: :paper
  defp win(:paper), do: :scissors
  defp win(:scissors), do: :rock
  def lose(shape), do: [:rock, :paper, :scissors] |> Enum.find(&(win(&1) == shape))

  def game_score(rounds) do
    rounds
    |> Stream.map(&score/1)
    |> Enum.sum()
  end

  @spec score({__MODULE__.t(), __MODULE__.t()}) :: integer()
  def score({player, you}) do
    shape_score(you) + win_score(player, you)
  end

  defp shape_score(:rock), do: 1
  defp shape_score(:paper), do: 2
  defp shape_score(:scissors), do: 3

  defp outcome_score(:win), do: 6
  defp outcome_score(:lose), do: 0
  defp outcome_score(:draw), do: 3

  defp win_score(player, you) when player == you, do: outcome_score(:draw)
  defp win_score(player, you) do
    case win(player) do
      ^you -> outcome_score(:win)
      _ -> outcome_score(:lose)
    end
  end
end
