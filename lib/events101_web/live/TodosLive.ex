defmodule Events101Web.TodosLive do
  use Events101Web, :live_view

  alias Events101.Projections
  alias Events101.Events
  alias Events101.Todos

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto mt-10">
      <h1 class="text-2xl font-bold mb-4">Todo List</h1>

      <div class="mb-6">
        <form phx-submit="add-todo" class="flex justify-between">
          <input
            type="text"
            name="title"
            placeholder="Add a new todo..."
            class="shadow appearance-none border rounded py-2 px-3 text-grey-darker mr-4 flex-grow"
            required
          />
          <button
            type="submit"
            class="flex-no-shrink p-2 border-2 rounded text-teal border-teal hover:text-white hover:bg-teal"
          >
            Add
          </button>
        </form>
      </div>

      <div class="bg-white shadow-md rounded">
        <table class="min-w-full leading-normal">
          <thead>
            <tr>
              <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                Title
              </th>
              <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                Status
              </th>
              <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                Delete
              </th>
              <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                Complete
              </th>
            </tr>
          </thead>
          <tbody>
            <%= for todo <- @todos do %>
              <tr class={if(todo.completed, do: "bg-green-100", else: "bg-white") <> " hover:bg-gray-100"}>
                <td class="px-5 py-3 border-b border-gray-200 text-sm">
                  <p class="text-gray-900 whitespace-no-wrap"><%= todo.title %></p>
                </td>
                <td class="px-5 py-3 border-b border-gray-200 text-sm">
                  <p class="text-gray-900 whitespace-no-wrap">
                    <%= if todo.completed, do: "Completed", else: "Pending" %>
                  </p>
                </td>
                <td class="px-5 py-3 border-b border-gray-200 text-sm">
                  <button
                    type="button"
                    phx-click="delete-todo"
                    phx-value-id={todo.id}
                    class="text-gray-900 whitespace-no-wrap"
                  >
                    🗑️
                  </button>
                </td>
                <td class="px-5 py-3 border-b border-gray-200 text-sm">
                  <button
                    :if={not todo.completed}
                    type="button"
                    phx-click="complete-todo"
                    phx-value-id={todo.id}
                    class="text-gray-900 whitespace-no-wrap"
                  >
                    ️✅
                  </button>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
      <div id="timeline" class=" flex items-center mt-10">
        <div class="timeline overflow-x-scroll flex flex-col transition ease-in-out duration-300">
          <button
            :for={event <- @events |> Enum.reverse()}
            phx-click="rewind"
            phx-value-event_id={event.id}
            class="mr-2 bg-blue-100 border rounded py-2 px-3"
          >
            <p class="event-name font-bold"><%= event.name %></p>
          </button>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    events = Events.get_events()
    todos = events |> Projections.list_todos()
    Phoenix.PubSub.subscribe(Events101.PubSub, "events")

    {:ok,
     assign(socket, todos: todos) |> assign(events: events) |> assign(current_events: events)}
  end

  def handle_event("rewind", %{"event_id" => event_id}, socket) do
    events = Events.rewind(event_id)
    todos = events |> Projections.list_todos()
    {:noreply, socket |> assign(todos: todos)}
  end

  def handle_event("add-todo", %{"title" => title}, socket) do
    Todos.create_todo(title)
    {:noreply, socket}
  end

  def handle_event("delete-todo", %{"id" => id}, socket) do
    Todos.delete_todo(id)
    {:noreply, socket}
  end

  def handle_event("complete-todo", %{"id" => id}, socket) do
    Todos.complete_todo(id)
    {:noreply, socket}
  end

  def handle_info(event, socket) do
    todos =
      event
      |> Projections.update_todos(socket.assigns.todos)
      |> sort_todos()

    {:noreply, assign(socket, todos: todos) |> assign(events: socket.assigns.events ++ [event])}
  end

  defp sort_todos(todos) do
    Enum.sort_by(todos, & &1.completed, :asc)
  end
end
