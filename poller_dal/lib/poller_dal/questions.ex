defmodule PollerDal.Questions do
  import Ecto.Query
  alias PollerDal.Repo
  alias PollerDal.Questions.Question

  # Inserts new "question" row into questions table in database
  def create_question(attrs) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  # Updates "question" row in Questions table
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  # delete "question" row in Question table
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  # query functions below --------------------------------

  def list_questions_by_area_id(area_id) do
    # elixir syntax which is converted to SQL and sent to postgres server
    # filters questions to match our perameter
    from(
      q in Question,
      where: q.area_id == ^area_id
    )
    |> preload(:choices)
    |> Repo.all()
  end

  # lists all questions
  def list_questions, do: Repo.all(Question)

  # Gets individual question from questions table in database
  #! signifies func will throw error is call fails
  def get_question!(id), do: Repo.get!(Question, id)

  # function to create question change set for poller_phx section of project
  def change_question(%Question{} = question) do
    Question.changeset(question, %{})
  end
end
