defmodule Events101.Todos do
  use GenServer

  alias Events101.Events
  alias Events101.Projections

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def create_todo(title) do
    GenServer.cast(__MODULE__, {:create_todo, title})
  end

  def complete_todo(id) do
    GenServer.cast(__MODULE__, {:complete_todo, id})
  end

  def delete_todo(id) do
    GenServer.cast(__MODULE__, {:delete_todo, id})
  end

  def edit_todo_title(id, title) do
    GenServer.cast(__MODULE__, {:edit_todo_title, id, title})
  end

  def init(_opts), do: {:ok, nil, {:continue, :project_current_state}}

  def handle_continue(:project_current_state, _state) do
    state = Events.get_events() |> Projections.list_todos()
    {:noreply, state}
  end

  def handle_cast({:create_todo, title}, state) do
    incomplete_todos_count = Enum.filter(state, fn s -> s.completed == false end) |> length()
    if incomplete_todos_count < 10 do
      new_todo = %{id: Ecto.UUID.generate(), title: title}
      new_state = [Map.put(new_todo, :completed, false) | state]
      Events.create_and_store_event("todo_created", new_todo)
      {:noreply, new_state}
    else
      {:noreply, state}
    end
  end

  def handle_cast({:complete_todo, id}, state) do
    new_state =
      state
      |> Enum.map(fn todo ->
        if todo.id == id and todo.completed == false do
          new_todo = Map.put(todo, :completed, true)
          Events.create_and_store_event("todo_completed", %{id: id})
          new_todo
        else
          todo
        end
      end)

    {:noreply, new_state}
  end

  def handle_cast({:edit_todo_title, id, title}, state) do
    new_state =
      state
      |> Enum.map(fn todo ->
        if todo.id == id do
          Events.create_and_store_event("todo_title_edited", %{id: id, title: title})
          Map.put(todo, :title, title)
        else
          todo
        end
      end)

    {:noreply, new_state}
  end

  def handle_cast({:delete_todo, id}, state) do
    if Enum.any?(state, fn s -> s.id == id end) do
      Events.create_and_store_event("todo_deleted", %{id: id})
      new_state = Enum.reject(state, fn s -> s.id == id end)
      {:noreply, new_state}
    else
      {:noreply, state}
    end
  end
end
