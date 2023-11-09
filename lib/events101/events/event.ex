defmodule Events101.Events.Event do
  defstruct [:id, :name, :data, :timestamp]

  def new(name, data) do
    %__MODULE__{
      id: Ecto.UUID.generate(),
      name: name,
      data: data,
      timestamp: DateTime.utc_now()
    }
  end
end
