defmodule Events101.Events.EventStore do
  use GenServer

  @name __MODULE__

  # ----------CLIENT-------------
  def start_link(opts) do
    GenServer.start_link(@name, opts, name: @name)
  end

  def get() do
    GenServer.call(@name, :get)
  end

  def persist_events(events) do
    GenServer.cast(@name, {:persist_events, events})
  end

  # --------SERVER---------------
  # This blocks
  # initial setting of the server
  def init(_opts), do: {:ok, nil, {:continue, :load_gen_server}}

  # Should Load Events From Database on load
  def handle_continue(:load_gen_server, _state), do: {:noreply, []}

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:persist_events, events}, state) do
    Enum.each(events, fn event ->
      Phoenix.PubSub.broadcast(Events101.PubSub, "events", event)
    end)

    {:noreply, events ++ state}
  end
end
