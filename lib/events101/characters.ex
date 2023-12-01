defmodule Events101.Characters do
  use GenServer

  alias Events101.Events
  alias Events101.Characters.Projections
  alias Events101.Characters.Commands

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def add_character(attrs) do
    GenServer.cast(__MODULE__, {:add_character, attrs})
  end

  def update_character(attrs) do
    GenServer.cast(__MODULE__, {:update_character, attrs})
  end

  def init(_opts), do: {:ok, nil, {:continue, :project_current_state}}

  def handle_continue(:project_current_state, _state) do
    state = Events.get_events() |> Projections.list_characters()
    {:noreply, state}
  end

  def handle_cast({:update_character, attrs}, state) do
    %{events: events, state: new_state} = Commands.update_character(state, attrs)
    Events.store_events(events)
    {:noreply, new_state}
  end

  def handle_cast({:add_character, attrs}, state) do
    %{events: events, state: new_state} = Commands.add_character(state, attrs)
    Events.store_events(events)
    {:noreply, new_state}
  end
end
