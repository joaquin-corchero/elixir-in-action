defmodule TodoList.CsvImporter do
  def import(file_location) do
    file_location
    |> get_entries
    |> TodoList.new
  end

  defp get_entries(file_location) do
    #2655
    {_, content} = File.read(file_location)
    |> String.split("/n")
    |> Enum.reduce(
        [],
        fn(line, entries) ->
          add_entry(todo_list_acc, entry)
        end
    )
  end
end
