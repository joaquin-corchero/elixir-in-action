 defmodule Infrastructure.CsvReaderShould do
   use ExUnit.Case
   alias Infrastructure.CsvReader, as: CsvReader

   test "read the file contents" do
     actual = CsvReader.read("test/data/todo_list.csv")
     assert actual == ["2016/6/15,First item", "2016/5/16,Second item"]
   end
 end
