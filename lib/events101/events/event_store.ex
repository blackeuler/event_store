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

  def rewind(event_id) do
    GenServer.call(@name, {:rewind, event_id})
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

  def handle_call({:rewind, event_id}, _from, state) do
    {events_before, _events_after} = Enum.split_while(state, fn event -> event.id != event_id end)
    events_to_keep = events_before ++ [Enum.find(state, fn event -> event.id == event_id end)]
    {:reply, events_to_keep, state}
  end

  def handle_cast({:persist_events, events}, state) do
    Enum.each(events, fn event ->
      Phoenix.PubSub.broadcast(Events101.PubSub, "events", event)
    end)

    {:noreply, state ++ events}
  end
end
