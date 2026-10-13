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
    # IO.puts("Calc: #{k} / #{n_fact} : Q= #{q}, R= #{r}")
    {val, remaining} = List.pop_at(nums, q)
    # IO.puts("Add #{val} to acc.")
    do_get_permutation(remaining, r, factorials, [val | acc])
  end

  @doc """
  This is the solution to the Leetcode Problem 68. "Text Justification".
  The task is to format a list of words into lines of text with a specified maximum width, ensuring that each line is fully justified (except for the last line, which should be left-justified).
  """
  @spec full_justify(words :: [String.t()], max_width :: integer) :: [String.t()]
  def full_justify(words, max_width) do
    ans = recursive_justify(words, max_width, 0, [], [])
    n = length(ans)
    inds = Enum.to_list(1..n)
    res_rev =
      Enum.zip_reduce(inds, ans, [], fn i, ls, acc ->
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

  @spec recursive_justify(
          wordlist :: [String.t()],
          max_width :: integer,
          curr :: integer,
          carrier :: [String.t()],
          res :: [[String.t()]]
        ) :: [[String.t()]]
  defp recursive_justify(wordlist, max_width, curr, carrier, res) do
    temp = hd(wordlist)
    remainder = tl(wordlist)

    if curr + String.length(temp) <= max_width do
      recursive_justify(
        remainder,
        max_width,
        curr + String.length(temp) + 1,
        [temp] ++ carrier,
        res
      )
    else
      recursive_justify(wordlist, max_width, 0, [], [carrier] ++ res)
    end
  end

  defp justification_formatter(wordlist, max_width) do
    w = Enum.reduce(wordlist, 0, fn item, acc -> String.length(item) + acc end)
    whitespaces = max_width - w
    q = div(whitespaces, length(wordlist) - 1)
    r = rem(whitespaces, length(wordlist) - 1)
    n = length(wordlist)
    inds = Enum.to_list(1..n)

    Enum.zip_reduce(inds, wordlist, "", fn i, s, acc ->
      cond do
        i <= r -> acc <> s <> String.duplicate(" ", q + 1)
        i < n -> acc <> s <> String.duplicate(" ", q)
        i == n -> acc <> s
      end
    end)
  end

  defp end_justification_formatter(wordlist, max_width) do
    n = length(wordlist)
    inds = Enum.to_list(1..n)

    rs =
      Enum.zip_reduce(inds, wordlist, "", fn i, s, acc ->
        if i != n do
          acc <> s <> " "
        else
          acc <> s
        end
      end)

    r = max_width - String.length(rs)
    rs <> String.duplicate(" ", r)
  end

  @doc """
  This is the solution to the Leetcode Problem 69. "Sqrt(x)". We need compute and return the square root of x, where x is a non-negative integer. Since the return type is an integer, the decimal digits are truncated, and only the integer part of the result is returned.
  """
  @spec my_sqrt(x :: integer) :: integer
  def my_sqrt(x) do
    if x == 1 || x == 0 do
      x
    else
      my_sqrt_meta(1, x - 1, x)
    end
  end

  defp my_sqrt_meta(l, r, _x) when l >= r - 1, do: l

  defp my_sqrt_meta(l, r, x) do
    mid = div(l + r, 2)
    cond do
      mid * mid > x -> my_sqrt_meta(l, mid, x)
      mid * mid < x -> my_sqrt_meta(mid, r, x)
      mid * mid == x -> mid
    end
  end

  @doc """
  This is the solution to the Leetcode Problem 77. "Combinations". We need to return all possible combinations of k numbers out of the range [1, n].

  This implementation tracks the current combination being built and uses recursion to explore all possible combinations.
  But without explicit backtracking, we put the sliced and enumerated list into next recursion, but the after-recursion results are more to be considered. This might be less efficient than the backtracking approach, but it is a valid solution.

  *Runtime: 165 ms on LeetCode Elixir*
  """
  @spec combine_1(n :: integer, k :: integer) :: [[integer]]
  def combine_1(n, k) do
    combine_meta(Enum.to_list(1..n), k)
  end

  @spec combine_meta(ls :: [integer], m :: integer) :: [[integer]]
  defp combine_meta(ls, 1) do
    Enum.map(ls, &[&1])
  end

  defp combine_meta([], _m), do: [[]]

  defp combine_meta(ls, m) do
    n = length(ls)

    Enum.zip_reduce(1..(n - m + 1), Enum.slice(ls, 0..(n - m)), [], fn ind, val, acc ->
      temp =
        combine_meta(Enum.slice(ls, min(ind, n), n - 1), m - 1) |> Enum.map(fn i -> [val | i] end)

      temp ++ acc
    end)
  end

  @doc """

  This is the solution to the Leetcode Problem 77. "Combinations". We need to return all possible combinations of k numbers out of the range [1, n].

  This implementation uses a backtracking approach to generate all possible combinations. In detail, on each recursion call, the function would consider either to include the current number in the combination or to skip it, and then recursively build the rest of the combination.
  This approach is straightforward, for it doesn't need to use the `Enum` module to construct enumerables.

  *Runtime: 99 ms on LeetCode Elixir*
  """
  @spec combine_2(n :: integer, k :: integer) :: [[integer]]
  def combine_2(n, k) do
    combine_backtrack(1, n, k, [])
  end

  defp combine_backtrack(_start, _n, 0, path), do: [Enum.reverse(path)]

  defp combine_backtrack(start, n, k, _path) when n - start + 1 < k, do: []

  defp combine_backtrack(start, n, k, path) do
    combine_backtrack(start + 1, n, k - 1, [start | path]) ++
      combine_backtrack(start + 1, n, k, path)
  end

  @doc """
  This is the solution to the Leetcode Problem 77. "Combinations". We need to return all possible combinations of k numbers out of the range [1, n].

  This implementation uses a flat mapping approach to generate all possible combinations. It recursively builds combinations by iterating through the range of numbers and collecting valid combinations into a list until the desired length is reached.

  *Runtime: 108 ms on LeetCode Elixir*
  """
  @spec combine(n :: integer, k :: integer) :: [[integer]]
  def combine(n, k) do
    combine_flatmapping(1, n, k, [])
  end

  defp combine_flatmapping(_start, _n, 0, path), do: [Enum.reverse(path)]

  defp combine_flatmapping(start, n, k, path) do
    max_start = n - k + 1

    if start > max_start do
      []
    else
      Enum.flat_map(start..max_start, &combine_flatmapping(&1 + 1, n, k - 1, [&1 | path]))
    end
  end
end
