defmodule DatabaseServer do
  def start do
    spawn(&loop/0)
  end

  defp loop do
    receive do
      {:run_query, caller, query_def} ->
        #runs the query and sends the results to the caller
        send(caller, {:query_result, run_query(query_def_)})
    end

    loop
  end

  #query execution
  defp run_query(query_def) do
    :timer.sleep(2000)
    "#{{query_def}} result"
  end

  
end
