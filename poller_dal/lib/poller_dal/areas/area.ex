defmodule PollerDal.Areas.Area do
  use Ecto.Schema
  import Ecto.Changeset

  schema "areas" do
    field(:name, :string)

    timestamps()
  end

  def changeset(area, attrs) do
    area
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
  end
end
