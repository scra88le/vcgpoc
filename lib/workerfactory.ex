defmodule WorkerFactory do
  use GenServer

  def start_link(events) do
    GenServer.start_link(__MODULE__, events)
  end

  def handle_cast(event = {:tick, {tn_id, _, _}}, events) do
    {:ok, pid} = Worker.start_link(events, tn_id)
    Process.register(pid, tn_id)
    GenServer.cast(pid, event)
    {:noreply, events}
  end
end
