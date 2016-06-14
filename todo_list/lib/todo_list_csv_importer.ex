defmodule TodoList.CsvImporter do
  alias Infrastructure.CsvReader, as: CsvReader
  alias Factories.TodoItemFactory, as: Factory

  def import(file_location \\ "") do
    CsvReader.read(file_location)
    |> Factory.create
    |> TodoList.new
  end
end
