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
