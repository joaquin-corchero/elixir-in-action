defmodule TodoList.EntryFromLineShould do
    use ExUnit.Case

    test "get an entry from a line" do
      line = "2016/6/15,First item"
      actual = TodoList.EntryFromLine.convert(line)
      assert actual == %{date: {2016, 6, 15}, title: "First item"}
    end
end
