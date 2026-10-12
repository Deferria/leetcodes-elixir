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
    #Enum.each(factorials, &IO.puts("#{&1}"))
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
    #IO.puts("Calc: #{k} / #{n_fact} : Q= #{q}, R= #{r}")
    {val, remaining} = List.pop_at(nums, q)
    #IO.puts("Add #{val} to acc.")
    do_get_permutation(remaining, r, factorials, [val | acc])
  end

  @doc """
  This is the solution to the Leetcode Problem 68. "Text Justification".
  The task is to format a list of words into lines of text with a specified maximum width, ensuring that each line is fully justified (except for the last line, which should be left-justified).
  """
  @spec full_justify(words :: [String.t], max_width :: integer) :: [String.t]
  def full_justify(words, max_width) do
    ans = recursive_justify(words, max_width, 0, [], [])
    n = length(ans)
    #IO.inspect(ans)
    inds = Enum.to_list(1..n)
    res_rev = Enum.zip_reduce(inds, ans, [], fn i, ls, acc ->
      cond do
        i == n -> [end_justification_formatter(ls, max_width)] ++ acc
        length(ls) == 1 -> [end_justification_formatter(ls, max_width)] ++ acc
        true -> [justification_formatter(ls, max_width)] ++ acc
      end
    end)
    Enum.reverse(res_rev)
  end

  defp recursive_justify([], _max_width, _curr, carrier, res) do
    tmp = [carrier] ++ res
    Enum.map(tmp, fn t -> Enum.reverse(t) end) |> Enum.reverse()
  end

  @spec recursive_justify(wordlist :: [String.t], max_width :: integer, curr :: integer, carrier :: [String.t], res :: [[String.t]]) :: [[String.t]]
  defp recursive_justify(wordlist, max_width, curr, carrier, res) do
    temp = hd(wordlist)
    remainder = tl(wordlist)
    if curr + String.length(temp) <= max_width do
      recursive_justify(remainder, max_width, curr + String.length(temp) + 1, [temp] ++ carrier, res)
    else
      recursive_justify(wordlist, max_width, 0, [], [carrier] ++ res)
    end
  end

  defp justification_formatter(wordlist, max_width) do
    w = Enum.reduce(wordlist, 0, fn item, acc -> String.length(item) + acc end)
    whitespaces = max_width - w
    q = div(whitespaces, length(wordlist)-1)
    r = rem(whitespaces, length(wordlist)-1)
    n = length(wordlist)
    inds = Enum.to_list(1..n)
    Enum.zip_reduce(inds, wordlist, "", fn i, s, acc ->
      cond do
        i <= r -> acc <> s <> String.duplicate(" ", q+1)
        i < n -> acc <> s <> String.duplicate(" ", q)
        i == n -> acc <> s
      end
    end)
  end

  defp end_justification_formatter(wordlist, max_width) do
    n = length(wordlist)
    inds = Enum.to_list(1..n)
    rs = Enum.zip_reduce(inds, wordlist, "", fn i, s, acc ->
      if i != n do
        acc <> s <> " "
      else
        acc <> s
      end
    end)
    r = max_width - String.length(rs)
    rs <> String.duplicate(" ", r)
  end
end
