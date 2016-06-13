defmodule TodoList.CsvImporter do
  def import(file_location) do
    file_location
    |> TodoList.FileLineReader.get_lines
    |> get_entries
    |> TodoList.new
  end

  defp get_entries(lines) do
    Enum.reduce(lines, [],
      fn(line, entries) ->
        entry = TodoList.EntryFromLine.convert(line)
        List.insert_at(entries, -1, entry)
      end
    )
  end
end
