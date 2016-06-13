defmodule TodoList.FileLineReaderShould do
  use ExUnit.Case

  test "get the correct number lines on a file" do
    actual = TodoList.FileLineReader.get_lines("test/data/todo_list.csv")
    assert actual == ["2016/6/15,First item", "2016/5/16,Second item"]
  end
end
