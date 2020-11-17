defmodule Blog.Datasets.PostsCategories.PostsCategory do
  use Ecto.Schema

  alias Blog.Datasets.Categories.Category
  alias Blog.Datasets.Posts.Post

  schema "posts_categories" do
    belongs_to :post, Post
    belongs_to :category, Category

    timestamps()
  end
end
