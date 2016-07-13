defmodule TodoServer do
  #How it works:
  #c("5_8_todo_server.ex")
  #todo_server = TodoServer.start
  #TodoServer.add_entry(todo_server, %{date: {2016,1,20}, title: "Activity 1"})
  #TodoServer.add_entry(todo_server, %{date: {2016,1,20}, title: "Activity 2"})
  #TodoServer.add_entry(todo_server, %{date: {2016,1,21}, title: "Activity 3"})
  #TodoServer.entries(todo_server,  {2016,1,21})
  #TodoServer.delete_entry(todo_server,  1)
  #TodoServer.entries(todo_server,  {2016,1,20})
  #TodoServer.update_entry(todo_server, 2, fn(item)-> Map.put(item, :title, "New title") end)
  #TodoServer.entries(todo_server,  {2016,1,20})

    def start() do
        spawn(fn -> loop(TodoList.new) end)
    end

    defp loop(current_value) do
        new_value = receive do
            message ->
                process_message(current_value, message)
        end

        loop(new_value)
    end

    def add_entry(todo_server, new_entry) do
      send(todo_server, {:add_entry, new_entry})
    end

    def entries(todo_server, date) do
      send(todo_server, {:entries, self, date})

      receive do
        {:todo_entries, entries} -> entries
      after 5000 ->
        {:error, :timeout}
      end
    end

    def delete_entry(todo_server, entry_id) do
      send(todo_server, {:delete_entry, entry_id})
    end

    def update_entry(todo_server, entry_id, updater_fun) do
      send(todo_server, {:update_entry, entry_id, updater_fun})
    end

    defp process_message(todo_list, {:add_entry, new_entry}) do
      TodoList.add_entry(todo_list, new_entry)
    end

    defp process_message(todo_list, {:entries, caller, date}) do
      send(caller, {:todo_entries, TodoList.entries(todo_list, date)})
      todo_list
    end

    defp process_message(todo_list, {:delete_entry, entry_id}) do
      TodoList.delete_entry(todo_list, entry_id)
    end

    defp process_message(todo_list, {:update_entry, entry_id, updater_fun}) do
      TodoList.update_entry(todo_list, entry_id, updater_fun)
    end
end

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

  def delete_entry(%TodoList{ entries: entries, auto_id: _auto_id} = todo_list, entry_id) do
    case entries[entry_id] do
      nil -> todo_list
      _old_entry ->
        {_, new_entries} = Map.pop(entries, entry_id)
        %TodoList{todo_list | entries: new_entries}
    end
  end

end
