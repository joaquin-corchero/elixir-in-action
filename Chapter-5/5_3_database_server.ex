defmodule DatabaseServer do
    def start do
    spawn(fn ->
      #keeping state
      connection = :random.uniform(1000)
      loop(connection)
    end)
  end

  defp loop (connection) do
    #awaits for the message with that format
    receive do
      {:run_query, caller, query_def} ->
          #runs the query and sends the results to the caller, with the pattern defined on the get_result
          query_result = run_query(connection, query_def)
          send(caller, {:query_result, query_result})
    end
    #keep the connection in the loop argument
    loop(connection)
  end

  #query execution
  defp run_query(connection, query_def) do
    :timer.sleep(2000)
    "Connection #{connection}: #{query_def} result"
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

    1..5 |> Enum.map(fn(_) -> DatabaseServer.get_result end)
  end

end
#to execute this:
#load the file c("5_3_database_server.ex")
#server_pid = DatabaseServer.start
#DatabaseServer.run_async(server_pid, "query 1")
#DatabaseServer.get_result
#DatabaseServer.run_async(server_pid, "query 2")
#DatabaseServer.get_result