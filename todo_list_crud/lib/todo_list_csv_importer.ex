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

defmodule TodoList.EntryFromLine do
  def convert(line) do
    [date, title] = String.split(line, ",")
    %{date: get_date(date), title: title}
  end

  defp get_date(date) do
    [year, month, day] = String.split(date, "/")
    {get_int(year), get_int(month), get_int(day)}
  end

  defp get_int(number) do
    {value, _} = Integer.parse(number)
    value
  end
end

defmodule TodoList.FileLineReader do
  import File

  def get_lines(file_location) do
    {_result, content} = File.read (file_location)
    String.replace(content,"\r\n", "\n" )
    |> String.strip
    |> String.split("\n")
  end
end
