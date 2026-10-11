defmodule LeetCodeLib do
  @moduledoc """
  Documentation for `LeetCodeLib`.

  This module contains solutions to various LeetCode problems in Elixir.
  """

  @doc """
  This is the solution to the Leetcode Problem 1. "Two Sum".
  The function returns the indices of the two numbers such that they add up to a specific target.
  """
  @spec two_sum(nums :: [integer], target :: integer) :: [integer]
  def two_sum(nums, target) do
    nums
    |> Enum.with_index()
    |> Enum.reduce_while(%{}, fn {num, i}, seen ->
      compl = target - num

      case Map.fetch(seen, compl) do
        {:ok, j} -> {:halt, [j, i]}
        :error -> {:cont, Map.put(seen, num, i)}
      end
    end)
  end

  @doc """
  This is the solution to the Leetcode Problem 62. "Unique Paths". That is, to find the number of unique paths from the top-left corner to the bottom-right corner of an m x n grid, moving only down or right.
  """
  @spec unique_paths(m :: integer, n :: integer) :: integer
  def unique_paths(m, n) do
    initial = List.duplicate(1, n)

    if m == 1 do
      1
    else
      temp =
        Enum.reduce(2..m, initial, fn _, dp ->
          Enum.scan(dp, 0, fn val, acc -> val + acc end)
        end)

      List.last(temp)
    end
  end

  @doc """
  This is the solution to the Leetcode Problem 60. "Permutation Sequence". That is, to find the k-th permutation sequence of numbers from 1 to n.

  Here we use recursion to build the permutation sequence step by step, calculating the factorial of the remaining numbers to determine which number to place next in the sequence.
  """
  @spec get_permutation(n :: integer, k :: integer) :: String.t()
  def get_permutation(n, k) do
    nums = Enum.to_list(1..n)
    k = k - 1
    factorials = Enum.scan(nums, 1, fn val, acc -> val * acc end)
    Enum.each(factorials, &IO.puts("#{&1}"))
    do_get_permutation(nums, k, factorials, []) |> Enum.join()
  end

  defp do_get_permutation([], _k, _factorials, acc) do
    Enum.reverse(acc)
  end

  defp do_get_permutation(nums, k, factorials, acc) do
    Enum.each(acc, &IO.puts("#{&1}"))
    len = length(nums)
    n_fact = Enum.at(factorials, len - 2)
    q = div(k, n_fact)
    r = rem(k, n_fact)
    IO.puts("Calc: #{k} / #{n_fact} : Q= #{q}, R= #{r}")
    {val, remaining} = List.pop_at(nums, q)
    IO.puts("Add #{val} to acc.")
    do_get_permutation(remaining, r, factorials, [val | acc])
  end
end
