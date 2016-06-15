run_query = fn(query_def) ->
  :timer.sleep(2000)

  "#{query_def} result"
end

run_query.("Long running query 1")

1..5 |> Enum.map(&run_query.("Long running queries #{&1}"))

#Creating processes
spawn(fn -> IO.puts(run_query.("Creating processes 1")) end)

#Helper lambda that concurrently runs the query and prints the result
async_query = fn(query_def) ->
  spawn(fn -> IO.puts(run_query.(query_def)) end)
end

async_query.("Helper lambda that concurrently runs the query and prints the result")

1..5 |> Enum.each(&async_query.("Concurrently executing the run_query #{&1}"))

#Message passing
send(self, "Sending a message from current process to itself")

#if no message is received then it will wait for the msg or if the msg
#can't be pattern matched
receive do
  message ->
    IO.puts("Message received: #{message}")
end

send(self, {:message, 1})

receive do
  {:message, id} ->
    IO.puts("Message received with pattern mathing: #{id}")
end

receive do
  message -> IO.inspect("Message received #{message}")
after 2000 -> IO.puts "Message didn't make it in the maximum allocated time"
end

send(self, {:message, 1})

receive_result = receive do
  {:message, x} -> x + 2
end

IO.inspect receive_result

#Process communciation
#caller stores the pid of the current process
#spawn will start a new process
#sends the message to the caller
async_query = fn(query_def) ->
  caller = self

  spawn(fn ->
    send(caller, {:query_result, run_query.(query_def)})
  end)
end

#Calls the run_query and sends the results to the shell process
1..5 |> Enum.each(&async_query.("query #{&1}"))

#reading from the current process mailbox
get_result = fn ->
  receive do
    {:query_result, result} -> result
  end
end

#pull messages from the mailbox into a single list
results = Enum.map(1..5, fn(_) -> get_result.() end)

#5.3 Statefull server process
