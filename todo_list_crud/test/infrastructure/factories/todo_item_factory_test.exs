defmodule Factories.TodoItemFactoryShould do
    use ExUnit.Case
    alias Factories.TodoItemFactory, as: Factory

    test "get one entry from a single item" do
      lines = ["2016/6/15,First item"]
      expected = [%{date: {2016, 6, 15}, title: "First item"}]
      actual = Factory.create(lines)
      assert actual == expected
    end

    test "get more than one entry from a list of lines" do
      lines = ["2016/6/15,First item", "2016/6/16,Second item"]
      expected = [%{date: {2016, 6, 15}, title: "First item"}, %{date: {2016, 6, 16}, title: "Second item"}]
      actual = Factory.create(lines)
      assert actual == expected
    end
end
