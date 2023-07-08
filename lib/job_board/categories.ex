defmodule JobBoard.Categories do
  alias JobBoard.Repo
  alias JobBoard.Jobs.Category
  import Ecto.Query

  def get_all() do
    query =
      from c in Category,
      select: c

    Repo.all(query)
  end
end
