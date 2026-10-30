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

  @doc """
  This is the solution to the Leetcode Problem 78. "Subsets". We need to return all possible subsets (the power set) of a given set of distinct integers.
  """
  @spec subsets(nums :: [integer]) :: [[integer]]
  def subsets(nums) do
    subset_meta(nums, [])
  end

  defp subset_meta([], current), do: [current]

  defp subset_meta(nums, current) do
    [a | remains] = nums
    subset_meta(remains, [a | current]) ++ subset_meta(remains, current)
  end

  @doc """
  This is the solution to the Leetcode Problem 97. "Interleaving String". We need to determine if a string s3 is formed by interleaving two strings s1 and s2.

  This implementation uses dynamic programming to solve the problem. It reduces the 2D dp table to a 1D array.

  *Runtime: 32 ms on LeetCode Elixir*
  """
  @spec is_interleave_1(s1 :: String.t(), s2 :: String.t(), s3 :: String.t()) :: boolean
  def is_interleave_1(s1, s2, s3) do
    m = String.length(s1)
    n = String.length(s2)

    cond do
      m + n != String.length(s3) -> false
      n == 0 -> s1 == s3
      m == 0 -> s2 == s3
      true ->
        c1 = String.to_charlist(s1)
        c2 = String.to_charlist(s2)
        c3 = String.to_charlist(s3)
        init =
          Enum.scan(Enum.to_list(1..n), true, fn j, acc ->
            acc and Enum.at(c2, j - 1) == Enum.at(c3, j - 1)
          end)

        dp =
          Enum.reduce(Enum.to_list(1..m), [true | init], fn i, acc ->
            prev = Enum.at(c1, i - 1) == Enum.at(c3, i - 1) and hd(acc)
            curr =
              Enum.scan(Enum.to_list(1..n), prev, fn j, acc_inner ->
                (acc_inner and Enum.at(c2, j - 1) == Enum.at(c3, i + j - 1)) or
                  (Enum.at(c1, i - 1) == Enum.at(c3, i + j - 1) and Enum.at(tl(acc), j - 1))
              end)
            [prev | curr]
          end)
        Enum.at(tl(dp), -1, true)
    end
  end

  @doc """
  This is a better solution to the Leetcode Problem 97. "Interleaving String".
  Here we use more functional programming style to reduce the 2D dp table to a 1D array, and we also use pattern matching to make the code more precise.

  *Runtime: 19 ms on LeetCode Elixir*
  """
  @spec is_interleave(s1 :: String.t, s2 :: String.t, s3 :: String.t) :: boolean
  def is_interleave(s1, s2, s3) do
    if String.length(s1) + String.length(s2) != String.length(s3) do
      false
    else
      c1 = [?^ | String.to_charlist(s1)]
      c2 = [?^ | String.to_charlist(s2)]
      c3 = [?^ | String.to_charlist(s3)]
      v = List.duplicate(true, length(c2))
      dp = Enum.reduce(c1, {v, c3}, fn ch1, {acc, lst} ->
        Enum.zip([acc, c2, lst]) |> Enum.scan(true, fn
          {true, _, ^ch1}, _ -> true
          {_, ch2, ch2}, true -> true
          _, _ -> false
        end)
        |> then(fn x -> {x, tl(lst)} end)
      end)
      elem(dp, 0) |> List.last()
    end
  end

  @doc """
  This is a solution to the Leetcode Problem 84. "Largest Rectangle in Histogram".
  It uses a stack-based approach to find the largest rectangle in the histogram, which might not be so functional.
  """
  @spec largest_rectangle_area(heights :: [integer]) :: integer
  def largest_rectangle_area(heights) do
    n = length(heights)
    {stack, area} = heights
      |> Enum.with_index()
      |> Enum.reduce({[], 0}, fn {h, i}, {st, a} ->
        {stack, area, start} = largest_rectangle_area_inner(st, i, h, a, i)
        IO.inspect(stack)
        {[{start, h} | stack], area}
      end)

    Enum.reduce(stack, area, fn {left_ind, h}, acc ->
      max(acc, (n-left_ind)*h)
    end)
  end

  defp largest_rectangle_area_inner([], _right_bound, _h, area, start), do: {[], area, start}

  defp largest_rectangle_area_inner([{left_bound, hprev} | rest], right_bound, h, area, start) do
    if h < hprev do
      area_new = max(area, (right_bound - left_bound) * hprev)
      largest_rectangle_area_inner(rest, right_bound, h, area_new, left_bound)
    else
      {[{left_bound, hprev} | rest], area, start}
    end
  end

  @doc """
  This is a solution to the Leetcode Problem 115. Distinct Subsequences.
  """
  @spec num_distinct(s :: String.t, t :: String.t) :: integer
  def num_distinct(s, t) do
    dp = Enum.reverse([1 | List.duplicate(0, String.length(t))])
    char_s = String.to_charlist(s)
    char_t = String.to_charlist(t) ++ [?^]
    Enum.reduce(Enum.reverse(char_s), dp, fn ch, lst ->
      shifted = tl(lst) ++ [hd(lst)]
      Enum.zip_with([char_t, lst, shifted], fn [ch2, i, j] ->
        if ch2 == ch do i+j else i end
      end)
    end) |> List.first()
  end

  @spec max_profit_inner(prices :: [integer], max_trans :: integer) :: integer
  defp max_profit_inner(prices, max_trans) do
    n = length(prices)
    dp = List.duplicate(0, n)
    Enum.reduce(1..(max_trans), dp, fn _k, ls ->
      shifted = [List.last(ls)] ++ Enum.slice(ls, 1..(n-1))
      #IO.inspect(shifted)
      Enum.scan(Enum.zip(prices, shifted), fn {price, dpprev}, {diff, dpi} ->
        diff_new = min(diff, price - dpprev)
        {diff_new, max(price - diff_new, dpi)}
      end) |> Enum.into([], fn {_diff, val} -> val end)
    end) |> List.last()
  end

  @doc """
  This is a solution to the Leetcode Problem 123. Best Time to Buy and Sell Stock III.
  This solution uses explicit dynamic programming to track the maximal profit achivable with at most k transactions. In this problem k=2.
  """
  @spec max_profit_1(prices :: [integer]) :: integer
  def max_profit_1(prices) do
    max_profit_inner(prices, 2)
  end

  @doc """
  This is a solution to the Leetcode Problem 123. Best Time to Buy and Sell Stock III.
  This solution is dedicated to the case of k=2. Then we can name the variables and update them in a clear way.
  """
  @spec max_profit(prices :: [integer]) :: integer
  def max_profit(prices) do
    init = {2147483647, 0, 2147483647, 0}
    {_, _, _, ans} = Enum.reduce(prices, init, fn p, {b1, s1, b2, s2} ->
      b1_new = min(b1, p)
      s1_new = max(s1, p-b1_new)
      b2_new = min(b2, p-s1_new)
      s2_new = max(s2, p-b2_new)
      {b1_new, s1_new, b2_new, s2_new}
    end)
    ans
  end

  @spec forward_bfs(q :: :queue.queue(String.t), found :: boolean, wordset :: MapSet.t(String.t), dists :: map, preces :: map, stopword :: String.t) :: {map, boolean}
  defp forward_bfs(q, found, wordset, dists, preces, stopword) do
    if :queue.is_empty(q) or found == true do
      {preces, found}
    else
      n = :queue.len(q)
      {q_new, found_new, dists_new, preces_new, visited_new} = Enum.reduce(1..n, {q, found, dists, preces, MapSet.new()}, fn _x, {q_old, found_old, dists_old, preces_old, visited_old} ->
        {{:value, curr}, q2} = :queue.out(q_old)
        {:ok, dist} = Map.fetch(dists_old, curr)
        if curr == stopword do
          {q2, true, dists_old, preces_old, visited_old}
        else
          curr_chars = String.to_charlist(curr)
          validities = Enum.flat_map(Enum.with_index(curr_chars), fn {t, i} ->
            Enum.map(String.to_charlist("abcdefghijklmnopqrstuvwxyz"), fn c ->
              if c == t do
                nil
              else
                testing = List.replace_at(curr_chars, i, c) |> List.to_string()
                cond do
                  testing == stopword -> {:vital, testing, curr}
                  MapSet.member?(wordset, testing) -> {:normal, testing, curr}
                  true -> nil
                end
              end
            end)
          end) |> Enum.reject(fn x -> x == nil end)
          Enum.reduce(validities, {q2, found_old, dists_old, preces_old, visited_old}, fn t, {q_take, found_take, dists_take, preces_take, visited_take} ->
            case t do
              {:vital, testing, curr} ->
                pnew = Map.get(preces_take, testing, MapSet.new()) |> MapSet.put(curr)
                {q_take, true, dists_take, Map.put(preces_take, testing, pnew), visited_take}
              {:normal, testing, curr} ->
                pnew = Map.get(preces_take, testing, MapSet.new()) |> MapSet.put(curr)
                cond do
                  not Map.has_key?(dists_take, testing) ->
                    {:queue.in(testing, q_take), found_take, Map.put_new(dists_take, testing, dist+1), Map.put(preces_take, testing, pnew), MapSet.put(visited_take, testing)}
                  Map.get(dists_take, testing) == dist + 1 -> {q_take, found_take, dists_take, Map.put(preces_take, testing, pnew), visited_take}
                  true -> {q_take, found_take, dists_take, preces_take, visited_take}
                end
              true ->
                {q_take, found_take, dists_take, preces_take, visited_take}
            end
          end)
        end
      end)
      forward_bfs(q_new, found_new, MapSet.difference(wordset, visited_new), dists_new, preces_new, stopword)
    end
  end

  defp back_dfs(word, target, path, _query) when word == target do
    [path]
  end

  defp back_dfs(word, target, path, query) do
    MapSet.to_list(Map.get(query, word)) |> Enum.flat_map(fn prec ->
      back_dfs(prec, target, [prec | path], query)
    end)
  end

  @doc """
  This is a solution to the Leetcode Problem 126. Word Ladder II.
  It uses simple BFS to find the shortest path and then DFS to construct the paths.
  """
  @spec find_ladders(begin_word :: String.t, end_word :: String.t, word_list :: [String.t]) :: [[String.t]]
  def find_ladders(begin_word, end_word, word_list) do
    word_set = MapSet.new(word_list) |> MapSet.delete(begin_word)
    q = :queue.new()
    if not MapSet.member?(word_set, end_word) do
      []
    else
      {preces, found} = forward_bfs(:queue.in(begin_word, q), false, word_set, Map.new() |> Map.put(begin_word, 0), Map.new(), end_word)
      if found == false do
        []
      else
        back_dfs(end_word, begin_word, [end_word], preces)
      end
    end
  end

  @doc """
  This is the first solution to the Leetcode Problem 128. Longest Consecutive Sequence.

  Keywords: Hashset, Recursion, Backtracking, Functional Programming
  """
  @spec longest_consecutive_1(nums :: [integer]) :: integer
  def longest_consecutive_1(nums) do
    elem(Enum.reduce(nums, {0, MapSet.new(nums)}, fn val, {acc, set} ->
      [h1, t1] = longest_consecutive_inner(val, set, 0, :f)
      [h2, t2] = longest_consecutive_inner(val-1, t1, h1, :b)
      #IO.puts("get: #{h1}, #{h2}")
      {max(acc, h2), t2}
    end), 0)
  end

  defp longest_consecutive_inner(val, set, res, mod) do
    if MapSet.member?(set, val) do
      #IO.puts("#{val} is in the set")
      if mod == :f do
        longest_consecutive_inner(val+1, MapSet.delete(set, val), res+1, :f)
      else
        longest_consecutive_inner(val-1, MapSet.delete(set, val), res+1, :b)
      end
    else
      [res, set]
    end
  end

  @doc """
  This is the second solution to the Leetcode Problem 128. Longest Consecutive Sequence. It uses sorting and a single pass to find the longest consecutive sequence.
  """
  @spec longest_consecutive(nums :: [integer]) :: integer
  def longest_consecutive([]), do: 0
  def longest_consecutive(nums) do
    nums
    |> Enum.sort()
    |> check_nums(1, 1)
  end

  defp next_count(x, y, count) do
    cond do
      y == x + 1 -> count + 1
      y == x -> count
      true -> 1
    end
  end

  defp check_nums([_head], count, biggest), do: max(count, biggest)

  defp check_nums([head, head_2 |tail], count, biggest) do
    new_count = next_count(head, head_2, count)
    check_nums([head_2 | tail], new_count, max(biggest, new_count))
  end
end
