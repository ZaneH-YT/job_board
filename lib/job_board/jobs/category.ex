defmodule JobBoard.Jobs.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias JobBoard.Jobs.Listing

  schema "categories" do
    field(:name, :string)

    has_many(:listings, Listing)
  end

  def changeset(category, params \\ %{}) do
    category
    |> cast(params, [
      :name
    ])
    |> validate_required([:name])
  end
end
