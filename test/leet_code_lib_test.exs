defmodule LeetCodeLibTest do
  use ExUnit.Case
  doctest LeetCodeLib

  test "two sum test 1" do
    assert LeetCodeLib.two_sum([2,7,11,15], 9) == [0, 1]
  end

  test "two sum test 2" do
    assert LeetCodeLib.two_sum([2,7,11,15], 17) == [0, 3]
  end

  test "unique paths test 2" do
    assert LeetCodeLib.unique_paths(3, 7) == 28
  end

  test "notest get permutation" do
    res = LeetCodeLib.get_permutation(3, 5)
    IO.puts("Res: #{res}")
  end

  test "notest text justification 1st pass" do
    res = LeetCodeLib.full_justify(
      ["This", "is", "an", "example", "of", "text", "justification."],
      16
    )
    IO.inspect(res)
  end

  test "test text justification" do
    res = LeetCodeLib.full_justify(
      ["This", "is", "an", "example", "of", "text", "justification."],
      16
    )
    expected = ["This    is    an","example  of text","justification.  "]
    assert res == expected
  end

  test "test my_sqrt" do
    assert LeetCodeLib.my_sqrt(9) == 3
  end

  test "notest combine meta" do
    res = LeetCodeLib.combine(5,3)
    IO.inspect(res)
  end

  test "notest subsets meta" do
    res = LeetCodeLib.subsets([1,2,3])
    IO.inspect(res)
  end

  test "test interleave string" do
    assert LeetCodeLib.is_interleave("dbbca", "aabcc", "aadbbcbcac") == true
  end

  test "test interleave string 2" do
    assert LeetCodeLib.is_interleave("dbbca", "aabcc", "aadbbbaccc") == false
  end

  test "test interleave string 3" do
    assert LeetCodeLib.is_interleave("db", "b", "cbb") == false
  end

  test "test largest rectangle area" do
    assert LeetCodeLib.largest_rectangle_area([2, 1, 5, 6, 2, 3]) == 10
  end

  test "test num distinct" do
    assert LeetCodeLib.num_distinct("babgbag", "bag") == 5
  end

  test "test max profit iii" do
    assert LeetCodeLib.max_profit([3,3,5,0,0,3,1,4]) == 6
  end

  test "test max profit iii 2" do
    assert LeetCodeLib.max_profit([1,3,4,6,2,3,2,4,0]) == 7
  end

  test "test max profit iii 3" do
    assert LeetCodeLib.max_profit([1,2,4,2,5,7,2,4,9,0]) == 13
  end

  test "test word ladder" do
    res = LeetCodeLib.find_ladders("hit", "cog", ["hot","dot","dog","lot","log","cog"])
    IO.inspect(res)
  end

  test "test longest consecutive sequence" do
    res = LeetCodeLib.longest_consecutive([100,3,200,1,4,2])
    assert res == 4
  end

  test "test longest consecutive sequence 2" do
    res = LeetCodeLib.longest_consecutive_1([7,1,2,3,4,5,6])
    assert res == 7
  end
end
