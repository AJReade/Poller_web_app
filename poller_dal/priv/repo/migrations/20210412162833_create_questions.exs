defmodule PollerDal.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add(:description, :string)
      #create database relation between this table and areas table
      #the :delete_all maintains referential integrity (deletes all questions associated)
      add(:area_id, references(:areas, on_delete: :delete_all))

      timestamps()
    end
    #As area_id field is a Fx making this an index will increase
    #speed of queries which use this column
    create(index(:questions, [:area_id]))
  end
end
