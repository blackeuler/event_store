defmodule Events101.ProjectionsTest do
  use ExUnit.Case

  alias Events101.Events
  alias Events101.Projections

  describe "todos" do
    test "returns an empty list when there are no todos" do
      events = []
      assert Projections.list_todos(events) == []
    end

    test "projects created todos" do
      events = [Events.create_new_event("todo_created", %{title: "My first todo", id: 1})]

      assert Projections.list_todos(events) == [
               %{id: 1, title: "My first todo", completed: false}
             ]
    end

    test "projects completed todos" do
      events = [
        Events.create_new_event("todo_created", %{title: "My first todo", id: 1}),
        Events.create_new_event("todo_completed", %{id: 1})
      ]

      assert Projections.list_todos(events) == [%{id: 1, title: "My first todo", completed: true}]
    end

    test "projects deleted todos" do
      events = [
        Events.create_new_event("todo_created", %{title: "My first todo", id: 1}),
        Events.create_new_event("todo_deleted", %{id: 1})
      ]

      assert Projections.list_todos(events) == []
    end

    test "projects updated todos" do
      events = [
        Events.create_new_event("todo_created", %{title: "My first todo", id: 1}),
        Events.create_new_event("todo_updated", %{id: 1, title: "My updated todo"})
      ]

      assert Projections.list_todos(events) == [
               %{id: 1, title: "My updated todo", completed: false}
             ]
    end
  end
end
