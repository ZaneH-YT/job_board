defmodule JobBoard.Jobs.Category do
  use Ecto.Schema
  alias JobBoard.Jobs.Listing
  import Ecto.Changeset

  schema "categories" do
    field :name, :string

    has_many :listings, Listing
  end

  def changeset(category, params \\ %{}) do
    category
    |> cast(params, [
      :name
    ])
    |> validate_required([:name])
  end
end
