defmodule PollerPhxWeb.AreaController do
  use PollerPhxWeb, :controller

  alias PollerDal.Areas
  alias PollerDal.Areas.Area

  def index(conn, _params) do
    areas = Areas.list_areas()
    render(conn, "index.html", areas: areas)
  end

  def new(conn, _params) do
    changeset = Areas.change_area(%Area{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"area" => area_params}) do
    case Areas.create_area(area_params) do
      {:ok, _area} ->
        conn
        |> put_flash(:info, "Area created successfully.")
        |> redirect(to: Routes.area_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "area" => area_params}) do
    area = Areas.get_area!(id)

    case Areas.update_area(area, area_params) do
      {:ok, _area} ->
        conn
        |> put_flash(:info, "Area updated successfully.")
        |> redirect(to: Routes.area_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", area: area, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    area = Areas.get_area!(id)
    changeset = Areas.change_area(area)
    render(conn, "edit.html", area: area, changeset: changeset)
  end

  def delete(conn, %{"id" => id}) do
    area = Areas.get_area!(id)
    # pattern match on :ok tupple if match fails server will reset its self
    {:ok, _area} = Areas.delete_area(area)

    conn
    |> put_flash(:info, "Area deleted successfully.")
    |> redirect(to: Routes.area_path(conn, :index))
  end
end
