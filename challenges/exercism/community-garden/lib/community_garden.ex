# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  @first_id 1

  def start(opts \\ []) do
    Agent.start(fn -> [@first_id, []] end, opts)
  end

  def list_registrations(pid) do
    Agent.get(pid, &Enum.fetch!(&1, 1))
  end

  def register(pid, register_to) do
    plot_id = Agent.get(pid, &Enum.fetch!(&1, 0))
    plot = %Plot{plot_id: plot_id, registered_to: register_to}

    Agent.update(pid, fn [_, plot_list] ->
      register_plot(plot_id, plot_list, plot)
    end)

    plot
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn [id_counter, plot_list] ->
      plot_list = release_plot(plot_id, plot_list)
      [id_counter, plot_list]
    end)
  end

  def get_registration(pid, plot_id) do
    Agent.get(pid, fn [_, plot_list] -> find_plot(plot_list, plot_id) end)
  end

  defp register_plot(id_counter, plot_list, plot) do
    [id_counter + 1, [plot | plot_list]]
  end

  defp release_plot(id, plot_list) do
    Enum.reject(plot_list, &(&1.plot_id === id))
  end

  defp find_plot(plot_list, plot_id) do
    plot = Enum.find(plot_list, &(&1.plot_id === plot_id))

    if plot do
      plot
    else
      {:not_found, "plot is unregistered"}
    end
  end
end
