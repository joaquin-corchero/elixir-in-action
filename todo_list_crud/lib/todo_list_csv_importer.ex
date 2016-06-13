defmodule TodoList.CsvImporter do
  def import(file_location) do
    file_location
    |> TodoList.FileReader.get_lines
    |> get_entries
    |> TodoList.new
  end

  defp get_entries(lines) do
    lines
    |> Enum.reduce([],
      fn(line, entries) ->
        raw = String.split(line, ",")
        date = get_date(String.split(raw[0], "/"))
        entries.push(%{date: date, title: raw[1]})
      end
    )
  end

  defp get_date([day, month, year]) do
    {Integer.parse(year), Integer.parse(month), Integer.parse(day) }
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
