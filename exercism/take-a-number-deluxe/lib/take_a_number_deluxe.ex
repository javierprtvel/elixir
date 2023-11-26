defmodule TakeANumberDeluxe do
  use GenServer

  alias TakeANumberDeluxe.State

  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, :current_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.cast(machine, :reset)
  end

  # Server callbacks
  @impl GenServer
  def init(init_arg) do
    min_number = Keyword.get(init_arg, :min_number)
    max_number = Keyword.get(init_arg, :max_number)
    auto_shutdown_timeout = Keyword.get(init_arg, :auto_shutdown_timeout) || :infinity

    result = State.new(min_number, max_number, auto_shutdown_timeout)

    case result do
      {:ok, state} -> {:ok, state, state.auto_shutdown_timeout}
      {:error, reason} -> {:stop, reason}
    end
  end

  @impl GenServer
  def handle_call(:current_state, _from, state) do
    reply = state
    {:reply, reply, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call(:queue_number, _from, state) do
    result = State.queue_new_number(state)

    case result do
      {:ok, queued_number, new_state} ->
        {:reply, {:ok, queued_number}, new_state, new_state.auto_shutdown_timeout}

      {:error, reason} ->
        {:reply, {:error, reason}, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call({:serve_queued_number, priority_number}, _from, state) do
    result = State.serve_next_queued_number(state, priority_number)

    case result do
      {:ok, queued_number, new_state} ->
        {:reply, {:ok, queued_number}, new_state, new_state.auto_shutdown_timeout}

      {:error, reason} ->
        {:reply, {:error, reason}, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_cast(:reset, state) do
    result = State.new(state.min_number, state.max_number, state.auto_shutdown_timeout)

    case result do
      {:ok, new_state} -> {:noreply, new_state, new_state.auto_shutdown_timeout}
      {:error, _reason} -> {:noreply, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

  @impl GenServer
  def handle_info(_msg, state) do
    {:noreply, state, state.auto_shutdown_timeout}
  end
end
