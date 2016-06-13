defmodule TodoListTests do

  defmodule TodoListTests.NewShould do
    use ExUnit.Case

    test "create a new todo list" do
      assert TodoList.new() == %TodoList{}
    end

    test "add entries using a list of entries" do
      entries = [
        %{date: {2016, 6, 15}, title: "First item"},
        %{date: {2016, 5, 16}, title: "Second item"}
      ]

      expected = %TodoList{
        auto_id: 3,
        entries: %{
          1 => %{date: {2016, 6, 15}, id: 1, title: "First item"},
          2 => %{date: {2016, 5, 16}, id: 2, title: "Second item"}
        }
      }

      actual = TodoList.new(entries)

      assert actual == expected
    end

  end

  defmodule TodoListTests.AddEntryShould do
    use ExUnit.Case

    test "add an item to an empty todo list" do
      expected =%TodoList{
        auto_id: 2,
        entries: %{1 => %{date: {2016, 5, 15}, id: 1, title: "First item"}}
      }

      actual = TodoList.new |>
        TodoList.add_entry(%{date: {2016, 05, 15}, title: "First item"})
      assert actual == expected
    end

    test "add an item to a non empty list" do
      expected = %TodoList{
        auto_id: 3,
        entries: %{
          1 => %{date: {2016, 5, 15}, id: 1, title: "First item"},
          2 => %{date: {2016, 5, 16}, id: 2, title: "Second item"}
        }
      }

      actual = TodoList.new |>
        TodoList.add_entry(%{date: {2016, 05, 15}, title: "First item"}) |>
        TodoList.add_entry(%{date: {2016, 05, 16}, title: "Second item"})
      assert actual == expected
    end

  end

  defmodule TodoListTests.EntriesShould do
    use ExUnit.Case

    test "return 1 matching entries by date" do
      expected = [%{date: {2016, 05, 15},  id: 1, title: "First item"}]
      data = TodoList.new |>
        TodoList.add_entry(%{date: {2016, 05, 15}, title: "First item"}) |>
        TodoList.add_entry(%{date: {2016, 05, 16}, title: "Second item"})

      actual = TodoList.entries(data, {2016, 05, 15})
      assert actual == expected
    end

    test "return more than 1 matching entries by date" do
      expected = [
        %{date: {2016, 05, 15},  id: 1, title: "First item"},
        %{date: {2016, 05, 15},  id: 3, title: "Third item"}
      ]
      data = TodoList.new |>
        TodoList.add_entry(%{date: {2016, 05, 15}, title: "First item"}) |>
        TodoList.add_entry(%{date: {2016, 05, 16}, title: "Second item"}) |>
        TodoList.add_entry(%{date: {2016, 05, 15}, title: "Third item"})

      actual = TodoList.entries(data, {2016, 05, 15})
      assert actual == expected
    end
  end

  defmodule TodoListTests.UpdateShould do
    use ExUnit.Case

    test "update an entry" do
      expected = %TodoList{
        auto_id: 3,
        entries: %{
          1 => %{date: {2016, 06, 15}, id: 1, title: "First item"},
          2 => %{date: {2016, 5, 16}, id: 2, title: "Second item"}
        }
      }

      data = TodoList.new |>
        TodoList.add_entry(%{date: {2016, 05, 15}, title: "First item"}) |>
        TodoList.add_entry(%{date: {2016, 05, 16}, title: "Second item"})

      actual = TodoList.update_entry(data, 1, fn(item)-> Map.put(item, :date, {2016, 06, 15}) end)
      assert actual == expected
    end

  end

  defmodule TodoListTests.DeleteShould do
    use ExUnit.Case

    test "delete an entry" do
      expected = %TodoList{
        auto_id: 3,
        entries: %{
          2 => %{date: {2016, 5, 16}, id: 2, title: "Second item"}
        }
      }

      data = TodoList.new |>
        TodoList.add_entry(%{date: {2016, 05, 15}, title: "First item"}) |>
        TodoList.add_entry(%{date: {2016, 05, 16}, title: "Second item"})

      actual = TodoList.delete_entry(data, 1)
      assert actual == expected
    end

    test "not delete an entry that does not exist" do
      expected =  %TodoList{auto_id: 3,
              entries: %{1 => %{date: {2016, 5, 15}, id: 1, title: "First item"},
                2 => %{date: {2016, 5, 16}, id: 2, title: "Second item"}}}

      data = TodoList.new |>
        TodoList.add_entry(%{date: {2016, 05, 15}, title: "First item"}) |>
        TodoList.add_entry(%{date: {2016, 05, 16}, title: "Second item"})

      actual = TodoList.delete_entry(data, 3)
      assert actual == expected
    end

end

  defmodule TodoListTests.FromCsvShould do
    use ExUnit.Case
    alias Infrastructure.CsvReader, as: CsvReader
    alias Factories.TodoItemFactory, as: Factory
    import Mock

    test "read the contents of the csv file" do
      file_location = "a.csv"
      with_mock CsvReader, [read: fn(_file_location) -> ["{2016/01/18}, Title 1", "{2016/02/18}, Title 2"] end] do
        with_mock Factory, [create: fn(_) -> [] end] do
          TodoList.from_file(file_location)
          assert called CsvReader.read(file_location)
        end
      end
    end

    test "transform each line on the file to a todo item" do
      file_location = "a.csv"
      file_content = ["{2016/01/18}, Title 1", "{2016/02/18}, Title 2"]
      with_mock CsvReader, [read: fn(_file_location) -> file_content end] do
        with_mock Factory, [create: fn(_) -> [] end] do
          TodoList.from_file(file_location)
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
          actual = TodoList.from_file(file_location)
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

      actual = TodoList.from_file("test/data/todo_list.csv")
      assert actual == expected
    end

  end
end
