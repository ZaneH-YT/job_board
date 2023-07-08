defmodule JobBoard.Repo.Migrations.CreateUserSaves do
  use Ecto.Migration

  def change do
    create table(:user_saves) do
      add(
        :user_id,
        references(
          :users,
          on_delete: :delete_all
        )
      )

      add(
        :listing_id,
        references(
          :listings,
          on_delete: :delete_all
        )
      )
    end

    create(
      unique_index(
        :user_saves,
        [:user_id, :listing_id]
      )
    )
  end
end
