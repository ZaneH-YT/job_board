defmodule JobBoard.Jobs.Listing do
  use Ecto.Schema
  import Ecto.Changeset
  alias JobBoard.Jobs.Category
  alias JobBoard.Accounts.{User, UserSave}

  schema "listings" do
    field(:title, :string)
    field(:description, :string)
    field(:company_image_url, :string)
    field(:company_web_url, :string)
    field(:company_name, :string)
    field(:is_saved, :boolean, virtual: true)

    belongs_to(:user, User)
    belongs_to(:category, Category)

    has_many(:user_saves, UserSave)

    timestamps()
  end

  def changeset(listing, params \\ %{}) do
    listing
    |> cast(params, [
      :title,
      :description,
      :company_image_url,
      :company_web_url,
      :company_name,
      :category_id,
      :user_id
    ])
    |> validate_required([
      :title,
      :company_name,
      :description,
      :category_id
    ])
  end
end
