defmodule TodoList do
  defstruct auto_id: 1, entries: Map.new
  alias Infrastructure.CsvReader, as: CsvReader
  alias Factories.TodoItemFactory, as: Factory

  def new, do: %TodoList{}#returns a new struct

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      fn(entry, todo_list_acc) ->
        add_entry(todo_list_acc, entry)
      end
    )
  end

  def from_file(file_location \\ "") do
    CsvReader.read(file_location)
    |> Factory.create
    |> TodoList.new
  end

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

  def update_entry(%TodoList{ entries: entries} = todo_list, entry_id, updater_fun) do
    case entries[entry_id] do
      nil -> todo_list
      old_entry ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(%TodoList{ entries: entries, auto_id: auto_id} = todo_list, entry_id) do
    case entries[entry_id] do
      nil -> todo_list
      old_entry ->
        {_, new_entries} = Map.pop(entries, entry_id)
        %TodoList{todo_list | entries: new_entries}
    end
  end

end
