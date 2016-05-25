defmodule MultiDict do
  def new do
    Map.new
  end

  def add(todo_list, key, value) do
    Map.update(todo_list, key, [value], fn(x)-> [value | x] end )
  end

  def get(todo_list, key) do
    Map.get(todo_list, key, [])
  end
end
