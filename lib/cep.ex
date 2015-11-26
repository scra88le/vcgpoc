#Central Event Processor
#Credit to Jon Harrington who's code I hacked around!

defmodule Cep do
  use Application
  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    {:ok, input} = GenEvent.start_link
    {:ok, output} = GenEvent.start_link
    {:ok, factory} = WorkerFactory.start_link(output)
    GenEvent.add_handler(input, Broker, factory)
    GenEvent.add_handler(output, Sink, nil)

    opts = [strategy: :one_for_one, name: Cep.Supervisor]

    #Lets fire up 10k tn's and watch what happens...
    children = 
      for h <- 1..10000 do
        tn_no = Integer.to_string(h)
        name = String.to_atom(tn_no)
        worker(Source,[input, 1000, name], id: h)
      end

    Supervisor.start_link(children, opts)

  end
end

