defmodule TodoList.CsvImporterShould do
  use ExUnit.Case, asyn: false
  import Mock

  test "read the contents of the file" do
    with_mock TodoList.FileLineReader, [get_lines: fn(_) -> ["2016/6/15,First item", "2016/5/16,Second item"] end] do
      TodoList.CsvImporter.import("a.csv")
      assert called TodoList.FileLineReader.get_lines("a.csv")
    end
  end

  test "convert each line of file to entry" do
    first_line = "2016/6/15,First item"
    second_line = "2016/5/16,Second item"
    with_mock TodoList.FileLineReader, [get_lines: fn(_) -> [first_line, second_line] end] do
      with_mock TodoList.EntryFromLine, [convert: fn(_) -> %{date: {2016, 6, 15}, title: "First item"} end] do
        TodoList.CsvImporter.import("a.csv")
        assert called TodoList.EntryFromLine.convert(first_line)
        assert called TodoList.EntryFromLine.convert(second_line)
      end
    end
  end

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
