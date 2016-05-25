defmodule TodoListTest do
  use ExUnit.Case

  test "Can create a new todo list" do
    assert TodoList.new() == %{}
  end

  test "Can add a new item to an empty todo list" do
    expected = %{{2016, 5, 15} => ["First item"]}
    actual = TodoList.new |>
      TodoList.add_entry({2016, 05, 15}, "First item")
    assert actual == expected
  end

  test "Can add an item to the same date" do
    expected = %{{2016, 5, 15} => ["Second item", "First item"]}
    actual = TodoList.new |>
      TodoList.add_entry({2016, 05, 15}, "First item") |>
      TodoList.add_entry({2016, 05, 15}, "Second item")
    assert actual == expected
  end

  test "Can add a new item to a populated todo list" do
    expected = %{{2016, 5, 15} => ["First item"], {2016, 5, 16} => ["Second item"]}
    actual = TodoList.new |>
      TodoList.add_entry({2016, 05, 15}, "First item") |>
      TodoList.add_entry({2016, 05, 16}, "Second item")

    assert actual == expected
  end

  test "Can get matching entries by date" do
    expected = ["First item"]
    todo_list = MultiDict.new |>
      TodoList.add_entry({2016, 05, 15}, "First item") |>
      TodoList.add_entry({2016, 05, 16}, "Second item")

    actual = TodoList.entries(todo_list, {2016, 5, 15})
    assert actual == expected
  end

  test "Can get more than one matching entry by date" do
    expected = ["Third item", "First item"]
    todo_list = TodoList.new |>
      TodoList.add_entry({2016, 05, 15}, "First item") |>
      TodoList.add_entry({2016, 05, 16}, "Second item") |>
      TodoList.add_entry({2016, 05, 15}, "Third item")

    actual = TodoList.entries(todo_list, {2016, 5, 15})
    assert actual == expected
  end
end
