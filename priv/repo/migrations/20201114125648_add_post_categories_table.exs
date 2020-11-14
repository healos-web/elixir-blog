defmodule Blog.Repo.Migrations.AddReferencesToPostsFromCategories do
  use Ecto.Migration

  def change do
    create table(:posts_categories) do
      add :post_id, references(:posts)
      add :category_id, references(:categories)

      timestamps
    end
  end
end
