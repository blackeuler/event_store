defmodule Events101.Events do
  alias Events101.Events.Event
  alias Events101.Events.EventStore

  def create_new_event(name, data) do
    Event.new(name, data)
  end

  def store_event(event) do
    EventStore.persist_events([event])
  end

  def store_events(events) do
    EventStore.persist_events(events)
  end

  def create_and_store_event(name, data) do
    name
    |> create_new_event(data)
    |> store_event()
  end

  def get_events() do
    EventStore.get()
  end

  def rewind(event_id) do
    EventStore.rewind(event_id)
  end
end
