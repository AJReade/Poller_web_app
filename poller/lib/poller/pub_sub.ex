defmodule Poller.PubSub do
  alias Phoenix.PubSub

  def area_topic(area_id), do: "area:#{area_id}"

  def server_name(), do: :poller

  def subscribe_area(area_id) do
    topic = area_topic(area_id)
    PubSub.subscribe(server_name(), topic)
  end

  def unsubscribe_area(area_id) do
    topic = area_topic(area_id)
    PubSub.unsubscribe(server_name(), topic)
  end

  def broadcast_area(area_id, choice_id, votes) do
    topic = area_topic(area_id)
    PubSub.broadcast(server_name(), topic, {:area_update, choice_id, votes})
  end
end
