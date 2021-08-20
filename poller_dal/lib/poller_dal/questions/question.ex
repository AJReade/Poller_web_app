defmodule PollerDal.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field(:description, :string)
    belongs_to(:area, PollerDal.Areas.Area)
    has_many(:choices, PollerDal.Choices.Choice)
    timestamps()
  end

  def changeset(question, attrs) do
    question
    |> cast(attrs, [:description, :area_id])
    |> validate_required([:description, :area_id])
    # verifies associated area id for question exists in area table
    |> assoc_constraint(:area)
  end
end
 