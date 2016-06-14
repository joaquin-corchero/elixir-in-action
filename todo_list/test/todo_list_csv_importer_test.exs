defmodule TodoList.CsvImporterShould do
  use ExUnit.Case
  alias TodoList.CsvImporter, as: Importer
  alias Infrastructure.CsvReader, as: CsvReader
  alias Factories.TodoItemFactory, as: Factory
  import Mock

  test "read the contents of the csv file" do
    file_location = "a.csv"
    with_mock CsvReader, [read: fn(_file_location) -> ["{2016/01/18}, Title 1", "{2016/02/18}, Title 2"] end] do
      with_mock Factory, [create: fn(_) -> [] end] do
        Importer.import(file_location)
        assert called CsvReader.read(file_location)
      end
    end
  end

  test "transform each line on the file to a todo item" do
    file_location = "a.csv"
    file_content = ["{2016/01/18}, Title 1", "{2016/02/18}, Title 2"]
    with_mock CsvReader, [read: fn(_file_location) -> file_content end] do
      with_mock Factory, [create: fn(_) -> [] end] do
        Importer.import(file_location)
        assert called Factory.create(file_content)
      end
    end
  end

  test "return contents of the file as list of todos" do
    file_location = "a.csv"
    file_content = ["{2016/01/18}, Title 1", "{2016/02/18}, Title 2"]
    factory_result = [%{date: {2016,01,18}, title: "Title 1"}, %{date: {2016,02,18}, title: "Title 2"}]
    expected = %TodoList{
      auto_id: 3,
      entries: %{
        1 => %{date: {2016,01,18}, id: 1, title: "Title 1"},
        2 => %{date: {2016,02,18}, id: 2, title: "Title 2"}
      }
    }
    with_mock CsvReader, [read: fn(_file_location) -> file_content end] do
      with_mock Factory, [create: fn(_file_content) -> factory_result end] do
        actual = Importer.import(file_location)
        assert actual == expected
      end
    end
  end

  test "return the contents from real file" do
    expected = %TodoList{
      auto_id: 3,
      entries: %{
        1 => %{date: {2016, 6, 15}, id: 1, title: "First item"},
        2 => %{date: {2016, 5, 16}, id: 2, title: "Second item"}
      }
    }

    actual = Importer.import("test/data/todo_list.csv")
    assert actual == expected
  end

end
