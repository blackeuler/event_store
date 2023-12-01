defmodule Events101.CharactersTest do
  use ExUnit.Case

  alias Events101.Events
  alias Events101.Characters.Projections
  alias Events101.Characters.Commands

  describe "character projections" do
    test "returns single character" do
      events = [
        Events.create_new_event("character_added", %{meaning: "I, me", character: "我", id: 1})
      ]

      assert Projections.get_character(events, 1) == %{id: 1, meaning: "I, me", character: "我"}
    end

    test "returns empty list when there are no characters" do
      events = []
      assert Projections.list_characters(events) == []
    end

    test "created characters" do
      events = [
        Events.create_new_event("character_added", %{meaning: "I, me", character: "我", id: 1})
      ]

      assert Projections.list_characters(events) == [
               %{id: 1, meaning: "I, me", character: "我"}
             ]
    end

    test "updated characters" do
      events = [
        Events.create_new_event("character_added", %{meaning: "I, me", character: "我", id: 1}),
        Events.create_new_event("character_updated", %{meaning: "I", character: "我", id: 1})
      ]

      assert Projections.list_characters(events) == [
               %{id: 1, meaning: "I", character: "我"}
             ]
    end
  end

  describe "character commands" do
    test "created characters" do
      %{events: events, state: _new_state} =
        Commands.add_character([], %{meaning: "I, me", character: "我"})

      assert [
               %{id: _id, meaning: "I, me", character: "我"}
             ] = Projections.list_characters(events)
    end

    test "cant update nonexistent character" do
      %{events: events_after_add, state: new_state} =
        Commands.add_character([], %{meaning: "I", character: "我"})

      %{events: events, state: _new_state} =
        Commands.update_character(new_state, %{
          id: 1,
          meaning: "I, me",
          character: "我"
        })

      events = events_after_add ++ events

      assert [
               %{id: _id, meaning: "I", character: "我"}
             ] = Projections.list_characters(events)
    end

    test "updated characters" do
      %{events: events_after_add, state: [char] = new_state} =
        Commands.add_character([], %{meaning: "I", character: "我"})

      %{events: events, state: _new_state} =
        Commands.update_character(new_state, %{
          id: char.id,
          meaning: "I, me",
          character: "我"
        })

      events = events_after_add ++ events

      assert [
               %{id: _id, meaning: "I, me", character: "我"}
             ] = Projections.list_characters(events)
    end
  end
end
