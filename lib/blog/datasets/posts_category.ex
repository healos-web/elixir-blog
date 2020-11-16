defmodule Blog.Datasets.PostsCategory do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Repo.Datasets.Categories.Category
  alias Blog.Repo.Datasets.Posts.Post

  schema "posts_categories" do
    belongs_to :post, Post
    belongs_to :category, Category

    timestamps()
  end
end
