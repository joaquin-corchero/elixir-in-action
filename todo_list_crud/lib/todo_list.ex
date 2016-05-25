defmodule TodoList do
  defstruct auto_id: 1, entries: Map.new

  def new, do: %TodoList{}#returns a new struct

  def add_entry(
    %TodoList{ auto_id: auto_id, entries: entries } = todo_list,
    %{date: date, title: title}= entry
  ) do
    entry = Map.put(entry, :id, auto_id)#set the new id to the entry passed

    new_entries = Map.put(todo_list, auto_id, entry)#adding new entry to list
    #reset the struct by updating the entries and the auto_id
    #Map update sintax is  %{map_to_update | field: value, field1: value1}
    #When using the update syntax (|), the VM is aware that no new keys will be added to the struct
    %TodoList{ todo_list | entries: new_entries, auto_id: auto_id + 1}
  end

end
