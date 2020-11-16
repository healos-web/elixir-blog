defmodule Blog.Repo.Migrations.AddCascadeDeleteToPostsCategories do
  use Ecto.Migration

  def change do
    drop(constraint(:posts_categories, :posts_categories_post_id_fkey))
    drop(constraint(:posts_categories, :posts_categories_category_id_fkey))
    
    alter table(:posts_categories) do
      modify(:post_id, references(:posts, on_delete: :delete_all))
      modify(:category_id, references(:categories, on_delete: :delete_all))
    end
  end
end
