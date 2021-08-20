defmodule PollerDal.Repo.Migrations.CreateChoices do
  use Ecto.Migration

  def change do
    create table(:choices) do
      add(:description, :string)
      add(:party, :integer)
      add(:votes, :integer)
      #create database relation between this table and questions table
      #the :delete_all maintains referential integrity (deletes all choices associated)
      add(:question_id, references(:questions, on_delete: :delete_all))

      timestamps()
    end
    #As question_id field is a Fx making this an index will increase
    #speed of queries which use this column
    create(index(:choices, [:question_id]))
  end
end
