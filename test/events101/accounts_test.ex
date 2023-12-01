defmodule Events101.AccountsTest do
  use ExUnit.Case

  alias Events101.Events
  alias Events101.Accounts.Projections

  describe "accounts" do
    test "returns an empty list when there are no todos" do
      events = []
      assert Projections.list_users(events) == []
    end

    test "after account creation" do
      events = [
        Events.create_new_event("user_registered", %{
          id: 1,
          email: "test@gmail.com",
          hashed_password: "123"
        })
      ]

      assert Projections.list_users(events) == [
               %{id: 1, email: "test@gmail.com"}
             ]
    end
  end
end
