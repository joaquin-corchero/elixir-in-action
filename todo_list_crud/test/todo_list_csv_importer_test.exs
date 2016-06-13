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
