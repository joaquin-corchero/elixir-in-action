defmodule LargeLinesTest do
  use ExUnit.Case
  doctest LargeLines

  test "empty list is returned if no lines larger than 80 chars" do
    fileLocation = "test/sample_data/large_lines01.txt"
    assert LargeLines.get_long_lines(fileLocation) == []
  end

  test "list is returned with the lines larger than 80 chars" do
    fileLocation = "test/sample_data/large_lines02.txt"
    assert LargeLines.get_long_lines(fileLocation) == ["0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789A", "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789B", "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789C"]
  end

  test "can return lengh of each line on a file" do
    fileLocation = "test/sample_data/large_lines01.txt"
    assert LargeLines.get_line_length(fileLocation) == [1,2,3,4]
  end

  test "can return the longest line of a file" do
    fileLocation = "test/sample_data/large_lines01.txt"
    assert LargeLines.get_longest_line(fileLocation) == "0123"
  end

  test "can get the number of words per line on a file" do
    fileLocation = "test/sample_data/large_lines03.txt"
    assert LargeLines.get_words_per_line(fileLocation) == [1,2,3,4,5,1]
  end
end
