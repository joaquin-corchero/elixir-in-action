defmodule TodoList do
  defstruct auto_id: 1, entries: Map.new

  def new, do: %TodoList{}#returns a new struct

  def add_entry(
    %TodoList{ entries: entries, auto_id: auto_id } = todo_list,
    entry
  ) do
    entry = Map.put(entry, :id, auto_id)#set the new id to the entry passed
    new_entries = Map.put(entries, auto_id, entry)#set new entries variable to existing ones plus the one just added
    %TodoList{ todo_list | entries: new_entries, auto_id: auto_id + 1}#reset todo_list
  end

  def entries(%TodoList{ entries: entries}, date) do
    entries
    |> Stream.filter(
      fn({_id, entry}) ->
        entry.date == date
      end)
    |> Enum.map(
      fn({_id, entry})->
        entry
      end)
  end

end
