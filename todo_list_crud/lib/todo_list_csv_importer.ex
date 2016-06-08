defmodule TodoList.CsvImporter do
  def import(file_location) do
    file_location
    |> get_entries
    |> TodoList.new
  end

  defp get_entries(file_location) do
    #2655
  end
end
