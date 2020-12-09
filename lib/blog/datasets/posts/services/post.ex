defmodule Blog.Datasets.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Datasets.PostsCategories.PostsCategory
  alias Blog.Datasets.Categories.Category
  alias Blog.Repo

  schema "posts" do
    field :published_at, :naive_datetime
    field :status, :string
    field :text, :string
    field :title, :string

    has_many :posts_categories, PostsCategory, on_delete: :delete_all
    many_to_many :categories, Category, join_through: "posts_categories", on_replace: :delete

    timestamps()
  end

  def changeset(post, %{category_ids: category_ids} = attrs) do
    post
    |> Repo.preload(:categories)
    |> changeset(Map.delete(attrs, :category_ids))
    |> put_assoc(:categories, Enum.map(category_ids, fn id -> %Category{id: id} end))
  end

  def changeset(post, attrs) do
    changeset = post
    |> cast(attrs, [:title, :text, :status, :published_at])
    |> validate_required([:title, :text, :status])
    |> validate_inclusion(:status, ["draft", "published", "require_moderation"])
  end
end
