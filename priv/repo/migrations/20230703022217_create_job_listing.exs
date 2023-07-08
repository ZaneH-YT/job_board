defmodule JobBoard.Repo.Migrations.CreateJobListing do
  use Ecto.Migration

  def change do
    create table(:listings) do
      add :title, :string, null: false
      add :description, :text
      add :company_image_url, :text
      add :company_web_url, :string
      add :company_name, :string, null: false

      add :category_id,
          references(
            :categories,
            on_delete: :delete_all
          ),
          null: false

      add :user_id,
          references(
            :users,
            on_delete: :delete_all
          )

      timestamps()
    end
  end
end
