defmodule PollerDal.Choices do
  import Ecto.Query
  alias PollerDal.Repo
  alias PollerDal.Choices.Choice

  # Inserts new "choice" row into choices table in database
  def create_choice(attrs) do
    %Choice{}
    |> Choice.changeset(attrs)
    |> Repo.insert()
  end

  # Updates "choice" row in choices table
  def update_choice(%Choice{} = choice, attrs) do
    choice
    |> Choice.changeset(attrs)
    |> Repo.update()
  end

  # delete "choice" row in choice table
  def delete_choice(%Choice{} = choice) do
    Repo.delete(choice)
  end

  # returns a changeset for a choice
  def update_choice(%Choice{} = choice) do
    Choice.changeset(choice, %{})
  end

  # query functions below --------------------------------

  def list_choices_by_question_id(question_id) do
    # elixir syntax which is converted to SQL and sent to postgres server
    # filters choice to match our perameter
    from(
      c in Choice,
      where: c.question_id == ^question_id
    )
    |> Repo.all()
  end

  # for when choices are running for multiple positions
  # e.g. local consituent and prime minster
  def list_choices_by_choice_ids(choice_ids) do
    from(
      c in Choice,
      where: c.id in ^choice_ids
    )
    |> Repo.all()
  end

  # lists all choices
  def list_choices, do: Repo.all(Choice)

  # Gets individual choice from choices table in database
  #! signifies func will throw error is call fails
  def get_choice!(id), do: Repo.get!(Choice, id)

  # function to create choice change set for poller_phx section of project
  def change_choice(%Choice{} = choice) do
    Choice.changeset(choice, %{})
  end

  #allows this module to be entry point for functions in choice
  #prevent redunent code
  defdelegate parties, to: Choice
  defdelegate party_ids, to: Choice
  defdelegate party_description(id), to: Choice
end
