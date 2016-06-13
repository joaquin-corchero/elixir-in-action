defmodule TodoList.CsvImporterShould do
  use ExUnit.Case

  test "add the entries" do
    expected = %TodoList{
      auto_id: 3,
      entries: %{
        1 => %{date: {2016, 6, 15}, id: 1, title: "First item"},
        2 => %{date: {2016, 5, 16}, id: 2, title: "Second item"}
      }
    }

    actual = TodoList.CsvImporter.import("test/data/todo_list.csv")
    assert actual == expected
  end
end

defmodule TodoList.FileLineReaderShould do
  use ExUnit.Case

  test "get the correct number lines on a file" do
    actual = TodoList.FileLineReader.get_lines("test/data/todo_list.csv")
    assert actual == ["2016/6/15,First item", "2016/5/16,Second item"]
  end
end

defmodule TodoList.EntryFromLineShould do
    use ExUnit.Case

    test "get an entry from a line" do
      line = "2016/6/15,First item"
      actual = TodoList.EntryFromLine.convert(line)
      assert actual == %{date: {2016, 6, 15}, title: "First item"}
    end
end
