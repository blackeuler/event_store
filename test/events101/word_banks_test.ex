defmodule Events101.WordBanksTest do
  use ExUnit.Case

  alias Events101.Events
  alias Events101.WordBanks.Projections
  alias Events101.WordBanks.Commands

  describe "character projections" do
    test "returns empty list when there are no banks" do
      events = []
      assert Projections.list_word_banks(events) == []
    end

    test "created word banks" do
      events = [
        Events.create_new_event("word_bank_created", %{name: "HSK 1", id: 1})
      ]

      assert Projections.list_word_banks(events) == [
               %{id: 1, name: "HSK 1", characters: []}
             ]
    end

    test "updated characters" do
      events = [
        Events.create_new_event("character_added", %{meaning: "I, me", character: "我", id: 1}),
        Events.create_new_event("word_bank_created", %{name: "HSK 1", id: 1}),
        Events.create_new_event("char_added_to_word_bank", %{id: 1, character_id: 1})
      ]

      assert Projections.list_word_banks(events) == [
               %{id: 1, name: "HSK 1", characters: [%{id: 1, meaning: "I, me", character: "我"}]}
             ]
    end
  end

end
