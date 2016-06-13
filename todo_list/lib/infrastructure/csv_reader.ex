 defmodule Infrastructure.CsvReader do
   def read(file_location) do
     {_result, content} = File.read (file_location)
     String.replace(content,"\r\n", "\n" )
     |> String.strip
     |> String.split("\n")
   end
 end
