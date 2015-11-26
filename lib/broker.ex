defmodule Broker do
  use GenEvent

  def init(factory) do
    {:ok, factory}
  end

  #If factory does exist for given TN_id, create one
  #If factory exists, forward load value to it for processing
  def handle_event(event = {:tick, {tn_id, _, _}}, factory) do
    case Process.whereis(tn_id) do
      nil -> GenServer.cast(factory, event)
      pid -> GenServer.cast(pid, event)
    end
    {:ok, factory}
  end

  def handle_event(_, factory) do
    {:ok, factory}
  end
end
