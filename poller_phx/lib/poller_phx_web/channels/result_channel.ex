defmodule PollerPhxWeb.ResultChannel do
  use PollerPhxWeb, :channel
  require Logger
  alias Poller.{PubSub, PollServer}

  def join("area:" <> area_id, _params, socket) do
    case Integer.parse(area_id) do
      {id, ""} ->
        socket = assign(socket, :area_id, id)
        PubSub.subscribe_area(id)
        poll = PollServer.get_poll(id)
        {:ok, %{"poll" => poll}, socket}

      _ ->
        {:error, %{reason: "Invalid Area"}}
    end
  end

  def handle_info({:area_update, choice_id, votes}, socket) do
    push(socket, "area_update", %{choice_id: choice_id, votes: votes})
    {:noreply, socket}
  end

  # def handle_info({:msg, msg}, socket) do
  #   push(socket, "msg", %{msg: msg})
  #   {:noreply, socket}
  # end

  def terminate(_reason, socket) do
    area_id = socket.assigns.area_id
    PubSub.unsubscribe_area(area_id)
    # Logger.info("termminating #{area_id}")
  end
end
