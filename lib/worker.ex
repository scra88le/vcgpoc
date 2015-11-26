defmodule Worker do
  use GenServer

  def start_link(events, tn_id) do
    GenServer.start_link(__MODULE__, {events, tn_id})
  end

  #Set averaging window as 60 minutes
  def init({events, tn_id}) do
    window = Window.timed(60)
    {:ok, %{tn_id: tn_id, events: events, window: window}}
  end

  #Create a rolling 60 minute average as updates from a TN come in
  def handle_cast({:tick, {tn_id, timestamp, value}}, state) do
     w = Window.add(state.window, {timestamp, value})
     avg = Enum.sum(w)/Enum.count(w)
     GenEvent.sync_notify(state.events, {:avg, {tn_id, timestamp, avg}})
     {:noreply, %{ state | window: w}}
   end
end
