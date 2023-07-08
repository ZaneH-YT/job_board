defmodule JobBoard.UserSaves do
  alias JobBoard.Accounts.UserSave
  alias JobBoard.Repo
  import Ecto.Query

  def is_saved?(listing_id, user_id) do
    query =
      from us in UserSave,
      where: us.listing_id == ^listing_id and us.user_id == ^user_id

    not is_nil(Repo.one(query))
  end

  def add_saved_listing_to_user!(listing_id, user_id) do
    %UserSave{
      listing_id: listing_id,
      user_id: user_id
    }
    |> Repo.insert!()
  end

  def remove_saved_listing_from_user!(listing_id, user_id) do
    query =
      from us in UserSave,
      where: us.listing_id == ^listing_id and us.user_id == ^user_id

    Repo.one(query)
    |> Repo.delete!()
  end
end
