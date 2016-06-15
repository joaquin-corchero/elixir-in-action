defmodule DatabaseServer do
  def start do
    spawn(&loop/0)
  end

  defp loop do
    receive do
      {:msg,contents} ->
    end

    loop
  end
end
