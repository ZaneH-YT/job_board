defmodule JobBoard.Accounts.UserSave do
  alias JobBoard.Accounts.User
  alias JobBoard.Jobs.Listing
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_saves" do
    belongs_to(:listing, Listing)
    belongs_to(:user, User)
  end

  def changeset(user_save, params \\ %{}) do
    user_save
    |> cast(params, [
      :listing_id,
      :user_id
    ])
    |> unique_constraint([:listing_id, :user_id])
  end
end
