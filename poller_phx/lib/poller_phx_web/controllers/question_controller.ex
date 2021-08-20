defmodule PollerPhxWeb.QuestionController do
  use PollerPhxWeb, :controller

  alias PollerDal.Questions
  alias PollerDal.Questions.Question
  alias PollerDal.Areas

  def index(conn, %{"area_id" => area_id}) do
    area = Areas.get_area!(area_id)
    questions = Questions.list_questions_by_area_id(area_id)
    render(conn, "index.html", area: area, questions: questions)
  end

  def new(conn, %{"area_id" => area_id}) do
    area = Areas.get_area!(area_id)
    changeset = Questions.change_question(%Question{})
    render(conn, "new.html", changeset: changeset, area: area)
  end

  def create(conn, %{"question" => question_params, "area_id" => area_id}) do
    question_params = Map.merge(question_params, %{"area_id" => area_id})

    case Questions.create_question(question_params) do
      {:ok, _question} ->
        conn
        |> put_flash(:info, "Question created successfully.")
        |> redirect(to: Routes.question_path(conn, :index, area_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "question" => question_params, "area_id" => area_id}) do
    question = Questions.get_question!(id)

    case Questions.update_question(question, question_params) do
      {:ok, _area} ->
        conn
        |> put_flash(:info, "Question updated successfully.")
        |> redirect(to: Routes.question_path(conn, :index, area_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", question: question, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id, "area_id" => area_id}) do
    area = Areas.get_area!(area_id)
    question = Questions.get_question!(id)
    changeset = Questions.change_question(question)

    render(conn, "edit.html",
      area: area,
      question: question,
      changeset: changeset
    )
  end

  def delete(conn, %{"id" => id, "area_id" => area_id}) do
    question = Questions.get_question!(id)
    # pattern match on :ok tupple if match fails server will reset its self
    {:ok, _area} = Questions.delete_question(question)

    conn
    |> put_flash(:info, "Question deleted successfully.")
    |> redirect(to: Routes.question_path(conn, :index, area_id))
  end
end
