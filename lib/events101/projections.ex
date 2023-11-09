defmodule Events101.Projections do
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
