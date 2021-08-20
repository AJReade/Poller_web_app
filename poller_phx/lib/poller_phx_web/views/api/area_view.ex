defmodule PollerPhxWeb.Api.AreaView do
  use PollerPhxWeb, :view
  alias __MODULE__

  def render("index.json", %{areas: areas}) do
    # we have many areas to render and to render each one
    # To use the render function in the AreaView module
    # pattern matching on the string below
    render_many(areas, AreaView, "show.json")
  end

  #call for each area in th areas list
  def render("show.json", %{area: area}) do
    %{id: area.id, name: area.name}
  end
end
