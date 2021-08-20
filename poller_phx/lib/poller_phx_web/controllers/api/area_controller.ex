defmodule PollerPhxWeb.Api.AreaController do
  use PollerPhxWeb, :controller

  alias PollerDal.Areas

  def index(conn, _params) do
    areas = Areas.list_areas()
    render(conn, "index.json", areas: areas)
  end

  def show(conn, %{"area_id" => area_id}) do
    area = Areas.get_area!(area_id)
    render(conn, "show.json", area: area)
  end
end
