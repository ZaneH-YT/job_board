defmodule JobBoard.Jobs do
  import Ecto.Query
  alias JobBoard.Repo
  alias JobBoard.Jobs.Listing

  def get_newest_listings() do
    query =
      from(l in Listing,
        select: l,
        order_by: l.inserted_at,
        preload: [:category]
      )

    Repo.all(query)
  end

  def get_by_id!(id) do
    query =
      from(l in Listing,
        select: l,
        where: l.id == ^id
      )

    Repo.one!(query)
  end

  def get_by_user_id(user_id) do
    query =
      from(l in Listing,
        select: l,
        where: l.user_id == ^user_id,
        preload: [:category]
      )

    Repo.all(query)
  end

  def create_listing(changeset) do
    Repo.insert(changeset)
  end

  def search_listings(search_term) do
    query =
      from(l in Listing,
        where:
          fragment("LOWER(?) LIKE LOWER(?)", l.title, ^"%#{search_term}%") or
            fragment("LOWER(?) LIKE LOWER(?)", l.description, ^"%#{search_term}%") or
            fragment("LOWER(?) LIKE LOWER(?)", l.company_name, ^"%#{search_term}%"),
        preload: [:category]
      )

    Repo.all(query)
  end

  def update_listing(attrs \\ %{}) do
    attrs
    |> Listing.changeset(attrs)
    |> Repo.update()
  end

  def delete_listing!(listing_id) do
    Repo.delete!(%Listing{id: listing_id})
  end
end
