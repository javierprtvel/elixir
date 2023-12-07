defmodule TakeANumber do
  @initial_state 0

  def start() do
    spawn(&loop/0)
  end

  defp loop(current_state \\ @initial_state)

  defp loop(:stop_the_machine) do
    :stopped
  end

  defp loop(current_state) do
    new_state =
      receive do
        {:report_state, sender_pid} -> send(sender_pid, current_state)
        {:take_a_number, sender_pid} -> send(sender_pid, current_state + 1)
        :stop -> :stop_the_machine
        _ -> current_state
      end

    loop(new_state)
  end
end
