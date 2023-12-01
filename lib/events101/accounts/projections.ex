defmodule Events101.Accounts.Projections do
  alias Events101.Events.Event

  def update_list_user(%Event{data: data} = event, users) do
    case event do
      %Event{name: "user_registered"} ->
        [Map.drop(data, [:hashed_password]) | users]
    end
  end

  def list_users(events) do
    Enum.reduce(events, [], &update_list_user/2)
  end
end
