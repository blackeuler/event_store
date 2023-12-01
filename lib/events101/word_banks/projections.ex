defmodule Events101.WordBanks.Projections do

  alias Events101.Characters.Projections, as: Characters


  def list_word_banks(events) do
    Enum.reduce(events, [], &update_word_banks/2)
  end

  def update_word_banks(event, banks) do
    case event do
      %Events101.Events.Event{name: "word_bank_created", data: data} ->
        data = Map.put(data, :characters, [])
        [data | banks]

      %Events101.Events.Event{
        name: "char_added_to_word_bank",
        data: %{id: id, character_id: char_id}
      } ->
        Enum.map(banks, fn
          %{id: ^id} = bank ->
            new_character = Characters.get_character(char_id)
            %{bank | characters: [new_character | bank.characters]}

          bank ->
            bank
        end)

      _ ->
        banks
    end
  end
end
