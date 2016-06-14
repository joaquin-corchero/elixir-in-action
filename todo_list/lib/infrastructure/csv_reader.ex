 defmodule Infrastructure.CsvReader do
   def read(file_location) do
     File.stream!(file_location)#reads the file and returns enum of lines
     |> Stream.map(fn(x) -> String.replace(x, "\n", "")  end)
   end
 end
