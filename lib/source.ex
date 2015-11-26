defmodule Source do
  use GenServer
  use Timex

  def start_link(events, interval, tn_id) do
    GenServer.start_link(__MODULE__, {events, interval, tn_id})
  end

  def load do
    :random.seed(:erlang.now())
    :random.uniform(4) + 10
  end

  def start_timer(state) do
    :erlang.send_after(state.interval, self(),
                       {:tick, {state.tn_id, state.time, load()}})
  end

  def init({events, interval, tn_id}) do
    state = %{events: events, tn_id: tn_id,
              time: trunc(Time.to_secs(Time.now)), interval: interval}
    start_timer(state)
    {:ok, state}
  end

  def handle_info(event, state) do
    GenEvent.sync_notify(state.events, event)
    ups = %{ state | time: state.time + :math.log((1-:random.uniform)) / (1/state.interval) * -1}
    start_timer(ups)
    {:noreply, ups}
  end
end
