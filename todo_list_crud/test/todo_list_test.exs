defmodule TodoListTest do
  use ExUnit.Case

  test "Can create a new todo list" do
    assert TodoList.new() == %TodoList{}
  end

  test "Can add an item to an empty todo list" do
    expected =%TodoList{
      auto_id: 2,
      entries: %{1 => %{date: {2016, 5, 15}, id: 1, title: "First item"}}
    }

    actual = TodoList.new |>
      TodoList.add_entry(%{date: {2016, 05, 15}, title: "First item"})
    assert actual == expected
  end

  test "Can add an item to a non empty list" do
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

  test "Can return 1 matching entries by date" do
    expected = [%{date: {2016, 05, 15},  id: 1, title: "First item"}]
    data = TodoList.new |>
      TodoList.add_entry(%{date: {2016, 05, 15}, title: "First item"}) |>
      TodoList.add_entry(%{date: {2016, 05, 16}, title: "Second item"})

    actual = TodoList.entries(data, {2016, 05, 15})
    assert actual == expected
  end

  test "Can return more than 1 matching entries by date" do
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

  test "Can update an entry" do
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
