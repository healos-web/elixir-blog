defmodule Blog.Datasets.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :published_at, :naive_datetime
    field :status, :string
    field :text, :string
    field :title, :string

    has_many :posts_categories, Blog.Datasets.PostsCategory
    has_many :categories, through: [:posts_categories, :categories]

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :text, :status, :published_at])
    |> validate_required([:title, :text, :status, :published_at])
  end
end
