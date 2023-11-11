defmodule Events101.Projections do
  def update_todos(event, todos) do
    case event do
      %Events101.Events.Event{name: "todo_created", data: data} ->
        data = Map.put(data, :completed, false)
        [data | todos]

      %Events101.Events.Event{name: "todo_completed", data: %{id: id}} ->
        Enum.map(todos, fn
          %{id: ^id} = todo ->
            Map.put(todo, :completed, true)

          todo ->
            todo
        end)

      %Events101.Events.Event{name: "todo_updated", data: %{id: id, title: title}} ->
        Enum.map(todos, fn
          %{id: ^id} = todo ->
            Map.put(todo, :title, title)

          todo ->
            todo
        end)

      %Events101.Events.Event{name: "todo_deleted", data: %{id: id}} ->
        Enum.filter(todos, fn
          %{id: ^id} = _todo ->
            false

          _ ->
            true
        end)

      _ ->
        todos
    end
  end

  def list_todos(events) do
    todos = Enum.reduce(events, [], &update_todos/2)
    sort_todos(todos)
  end

  defp sort_todos(todos) do
    Enum.sort_by(todos, & &1.completed, :asc)
  end

  def todo_count(events) do
    Enum.count(events, fn
      %Events101.Events.Event{name: "todo_created"} -> true
      _ -> false
    end)
  end

  def completed_count(events) do
    Enum.count(events, fn
      %Events101.Events.Event{name: "todo_completed"} -> true
      _ -> false
    end)
  end

  def todo_status(events) do
    if todo_count(events) == completed_count(events) do
      "All done!"
    else
      "Still working..."
    end
  end

  def show_todo(id, events) do
    Enum.reduce(events, nil, fn
      %Events101.Events.Event{id: ^id, name: "todo_created", data: data}, _ ->
        data

      %Events101.Events.Event{id: ^id, name: "todo_completed", data: data}, _ ->
        data

      _, acc ->
        acc
    end)
  end
end
