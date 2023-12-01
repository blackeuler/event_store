defmodule Events101Web.EventsLive do
  use Events101Web, :live_view

  alias Events101.Projections
  alias Events101.Events
  alias Events101.Todos

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-100 py-6 flex flex-col justify-center sm:py-12">
      <div class="relative py-3 sm:max-w-xl sm:mx-auto">
        <div class="absolute inset-0 bg-gradient-to-r from-purple-400 to-pink-500 shadow-lg transform skew-y-6 sm:skew-y-0 sm:-rotate-6 sm:rounded-3xl">
        </div>
        <div class="relative px-4 py-10 bg-white shadow-lg sm:rounded-3xl sm:p-20">
          <div class="max-w-md mx-auto">
            <div>
              <h1 class="text-2xl font-semibold">Enter Event Details</h1>
            </div>
            <div class="divide-y divide-gray-200">
              <div class="py-8 text-base leading-6 space-y-4 text-gray-700 sm:text-lg sm:leading-7">
                <div class="flex flex-col">
                  <label class="leading-loose">Event Name</label>
                  <input
                    type="text"
                    class="px-4 py-2 border focus:ring-indigo-500 focus:border-indigo-500 w-full sm:text-sm border-gray-300 rounded-md focus:outline-none text-gray-600"
                    placeholder="e.g., Brush Teeth"
                  />
                </div>
                <div class="flex flex-col">
                  <label class="leading-loose">Event Data (Key-Value Pairs)</label>
                  <div id="key-value-pairs">
                    <div :for={pair <- @pairs} class="flex items-center space-x-3 mb-2">
                      <input
                        type="text"
                        class="px-4 py-2 border focus:ring-indigo-500 focus:border-indigo-500 w-full sm:text-sm border-gray-300 rounded-md focus:outline-none text-gray-600"
                        placeholder="Key"
                      />
                      <input
                        type="text"
                        class="px-4 py-2 border focus:ring-indigo-500 focus:border-indigo-500 w-full sm:text-sm border-gray-300 rounded-md focus:outline-none text-gray-600"
                        placeholder="Value"
                      />
                      <button
                        type="button"
                        class="p-2 rounded-full bg-red-500 text-white"
                        onclick="removeKeyValuePair(this)"
                      >
                        -
                      </button>
                    </div>
                  </div>
                  <button
                    type="button"
                    class="mt-2 text-sm text-blue-500"
                    phx-click="add_key_value_pair"
                  >
                    + Add More
                  </button>
                </div>
                <div class="flex items-center space-x-4 mt-4">
                  <button class="flex justify-center items-center w-full text-white px-4 py-3 rounded-md bg-indigo-500 hover:bg-indigo-600">
                    <span>Submit Event</span>
                  </button>
                  <button class="flex justify-center items-center w-full text-indigo-500 px-4 py-3 rounded-md border border-indigo-500 hover:bg-gray-100">
                    <span>Cancel</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket = assign(socket, pairs: [])
    {:ok, socket}
  end

  def handle_event("add_key_value_pair", _, socket) do
    socket = assign_key_value_pair(socket, "", "")
    {:noreply, socket}
  end

  def assign_key_value_pair(socket, key, value) do
    pairs = socket.assigns.pairs
    assign(socket, pairs: [%{key: key, value: value}] ++ pairs)
  end
end
