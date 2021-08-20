defmodule Poller.PollServer do
  use GenServer
  alias Poller.{Poll, PubSub}
  alias PollerDal.{Questions, Choices}

  @save_time 10 * 60 * 1000

  def start_link(area_id) do
    name = area_name(area_id)
    GenServer.start_link(__MODULE__, area_id, name: name)
  end

  def area_name(area_id), do: :"area:#{area_id}"

  def add_question(area_id, question) do
    name = area_name(area_id)
    GenServer.call(name, {:add_question, question})
  end

  def vote(area_id, choice_id) do
    name = area_name(area_id)
    GenServer.call(name, {:add_vote, choice_id})
  end

  def get_poll(area_id) do
    name = area_name(area_id)
    GenServer.call(name, :get)
  end

  # CallBacks

  def init(area_id) do
    schedule_save()
    poll = init_poll(area_id)
    {:ok, poll}
  end

  defp init_poll(area_id) do
    questions = Questions.list_questions_by_area_id(area_id)

    area_id
    |> Poll.new()
    |> Poll.add_questions(questions)
  end

  def handle_call({:add_question, question}, _from, poll) do
    poll = Poll.add_question(poll, question)
    {:reply, poll, poll}
  end

  def handle_call({:add_vote, choice_id}, _from, poll) do
    poll = Poll.vote(poll, choice_id)
    votes = Map.get(poll.votes, choice_id, 0)
    PubSub.broadcast_area(poll.area_id, choice_id, votes)
    {:reply, poll, poll}
  end

  def handle_call(:get, _from, poll) do
    questions =
      for question <- poll.questions do
        choices =
          for choice <- question.choices do
            votes = Map.get(poll.votes, choice.id, 0)

            choice
            |> Map.from_struct()
            |> Map.put(:votes, votes)
          end

        question
        |> Map.from_struct()
        |> Map.put(:choices, choices)
      end

    result = %{
      area_id: poll.area_id,
      questions: questions
    }

    {:reply, result, poll}
  end

  def save_votes(poll) do
    poll.votes
    |> Map.keys()
    |> Choices.list_choices_by_choice_ids()
    |> Enum.each(fn choice ->
      current_votes = Map.get(poll.votes, choice.id, choice.votes)

      if current_votes != choice.votes do
        Choices.update_choice(choice, %{votes: current_votes})
      end
    end)
  end

  def schedule_save(), do: Process.send_after(self(), :save, @save_time)

  def handle_info(:save, poll) do
    save_votes(poll)

    schedule_save()
    {:noreply, poll}
  end

  def terminate(_reason, poll), do: save_votes(poll)
end
