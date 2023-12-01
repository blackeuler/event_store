defmodule Events101.Characters.Commands do
  alias Events101.Events

  def add_character(state, %{meaning: meaning, character: char} = _attrs) do
    new_char = %{id: Ecto.UUID.generate(), meaning: meaning, character: char}
    new_state = [new_char | state]
    %{events: [Events.create_new_event("character_added", new_char)], state: new_state}
  end

  def update_character(state, %{id: id, meaning: meaning, character: char} = _attrs) do
    if Enum.all?(state, fn char -> char.id != id end) do
      %{events: [], state: state}
    else
      new_char = %{id: id, meaning: meaning, character: char}

      new_state =
        Enum.map(state, fn char ->
          if char.id == id do
            new_char
          else
            char
          end
        end)

      %{events: [Events.create_new_event("character_updated", new_char)], state: new_state}
    end
  end
end
