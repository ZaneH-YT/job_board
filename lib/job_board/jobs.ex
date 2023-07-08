defmodule JobBoard.Jobs do
  import Ecto.Query
  alias JobBoard.Repo
  alias JobBoard.Jobs.Listing

  def get_newest_listings() do
    query =
      from(l in Listing,
        select: l,
        order_by: l.inserted_at,
        limit: 8,
        preload: [:category]
      )

    Repo.all(query)
  end
end
