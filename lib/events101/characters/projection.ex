defmodule Events101.Characters.Projections do
  def update_characters(event, chars) do
    case event do
      %Events101.Events.Event{name: "character_added", data: data} ->
        [data | chars]

      %Events101.Events.Event{name: "character_updated", data: %{id: id, meaning: meaning}} ->
        Enum.map(chars, fn
          %{id: ^id} = char ->
            Map.put(char, :meaning, meaning)

          char ->
            char
        end)

      _ ->
        chars
    end
  end

  def list_characters(events) do
    Enum.reduce(events, [], &update_characters/2)
  end

  def get_character(events, id) do
    Enum.reduce(events, nil, fn
      %Events101.Events.Event{name: "character_added", data: %{id: ^id} = data}, _ ->
        data

      %Events101.Events.Event{name: "character_updated", data: %{id: ^id, meaning: meaning}},
      old_data ->
        Map.put(old_data, :meaning, meaning)

      _, char ->
        char
    end)
  end
end
