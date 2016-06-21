defmodule DatabaseServer do
  def start do
    spawn(&loop/0)
  end

  defp loop do
    receive do #--> awaits for the message with that format
      {:run_query, caller, query_def} ->
        #runs the query and sends the results to the caller, with the pattern defined on the get_result
        send(caller, {:query_result, run_query(query_def)})
    end

    loop
  end

  #query execution
  defp run_query(query_def) do
    :timer.sleep(2000)
    "#{query_def} result"
  end

#puts the query on the message queue that matches with the pattern defined on the loop function
  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self, query_def})
  end

  def get_result do
    receive do
      {:query_result, result} -> result
    after 5000 ->
      {:error, :timeout}
    end
  end

  def create_and_consume_server_pool do
    #pool of database server processes
    pool = 1..100 |> Enum.map(fn(_) -> DatabaseServer.start end)

    #execute queries randomly using the pool
    1.. 5 |> Enum.each(fn(query_def) ->
      server_pid =  Enum.at(pool, :random.uniform(100) - 1)#selects the random process
      DatabaseServer.run_async(server_pid,  query_def) #runs the query on the process
    end)

    1..5 |> Enum.map(fn(_) -> get_result end)
  end

end
#to execute this:
#load the file c("5_3_database_server.ex")
#server_pid = DatabaseServer.start
#DatabaseServer.run_async(server_pid, "query 1")
#DatabaseServer.get_result
#DatabaseServer.run_async(server_pid, "query 2")
#DatabaseServer.get_result
