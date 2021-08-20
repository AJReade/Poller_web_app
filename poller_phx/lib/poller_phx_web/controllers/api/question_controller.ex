defmodule PollerPhxWeb.Api.QuestionController do
  use PollerPhxWeb, :controller

  alias PollerDal.Questions

  def index(conn, %{"area_id" => area_id}) do
    questions = Questions.list_questions_by_area_id(area_id)
    render(conn, "index.json", questions: questions)
  end
end
