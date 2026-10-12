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

  test "notest text justification" do
    res = LeetCodeLib.full_justify(
      ["This", "is", "an", "example", "of", "text", "justification."],
      16
    )
    expected = ["This    is    an","example  of text","justification.  "]
    assert res == expected
  end
end
