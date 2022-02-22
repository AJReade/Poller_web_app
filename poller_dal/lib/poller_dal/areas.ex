defmodule PollerDal.Areas do
  # this file will contain all fucntions for typical database CRUD operations on Areas, (API)
  alias PollerDal.Repo
  alias PollerDal.Areas.Area

  # inserts new "area" row into areas table in database
  def create_area(attrs) do
    %Area{}
    |> Area.changeset(attrs)
    |> Repo.insert()
  end

  # Updates "area" row in areas table
  def update_area(%Area{} = area, attrs) do
    area
    |> Area.changeset(attrs)
    |> Repo.update()
  end

  # delete "area" row in areas table
  def delete_area(%Area{} = area) do
    Repo.delete(area)
  end

  # query functions below --------------------------------
  # lists all Areas
  def list_areas, do: Repo.all(Area)

  # Gets individual Area from areas table in database
  #! signifies func will throw error is call fails
  def get_area!(id), do: Repo.get!(Area, id)

  # function to create area change set for poller_phx section of project
  def change_area(%Area{} = area) do
    Area.changeset(area, %{})
  end
end
