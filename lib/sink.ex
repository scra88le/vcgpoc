defmodule Sink do
  use GenEvent
  use Timex

  #Represents the System Operator Transactive Load
  #Just a simple toy implementation that takes the average load for each TN
  #and dumps it to the screen
  def handle_event({:avg, {tn_id, timestamp, value}}, factory) do
    date = Date.from(timestamp, :secs) |> DateFormat.format!("{RFC1123}")
    IO.puts("#{date}, TN ID: #{tn_id}, average load: #{value}")
    {:ok, factory}
  end

  def handle_event(_, factory) do
    {:ok, factory}
  end
end
