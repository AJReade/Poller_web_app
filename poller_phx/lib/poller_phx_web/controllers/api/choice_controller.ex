defmodule PollerPhxWeb.Api.ChoiceController do
  use PollerPhxWeb, :controller

  alias PollerDal.Choices
  alias Poller.{PollServer, PollSupervisor}

  def index(conn, %{"question_id" => question_id}) do
    choices = Choices.list_choices_by_question_id(question_id)
    render(conn, "index.json", choices: choices)
  end

  def vote(conn, %{"area_id" => area_id, "choice_id" => choice_id}) do
    area_id = String.to_integer(area_id)
    choice_id = String.to_integer(choice_id)
    start_poll(area_id)
    PollServer.vote(area_id, choice_id)
    send_resp(conn, 204, "")
  end

  defp start_poll(area_id) do
    area_name = PollServer.area_name(area_id)

    case Process.whereis(area_name) do
      nil -> PollSupervisor.start_poll(area_id)
      pid -> pid
    end
  end
end
