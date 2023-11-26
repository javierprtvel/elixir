defmodule Chessboard do
  def rank_range, do: 1..8
  def file_range, do: ?A..?H
  def ranks, do: for(i <- rank_range(), do: i)
  def files, do: for(i <- file_range(), do: <<i>>)
end
