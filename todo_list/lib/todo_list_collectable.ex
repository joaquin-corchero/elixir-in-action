defimpl Collectable, for: TodoList do
  #returns the appender lambda
  def into(original) do
    {original, &into_callback/2}
  end

  #Methods for the appender implementation
  defp into_callback(todo_list, {:cont, entry}) do
    TodoList.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list, :done), do: todo_list

  defp into_callback(todo_list, :halt), do: :ok

end
