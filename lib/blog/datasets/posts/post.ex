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

  # def changeset(post, )

  @doc false
  def changeset(post, attrs) do
    attrs = update_attrs(attrs)

    post
    |> cast(attrs, [:title, :text, :status, :published_at])
    |> validate_required([:title, :text, :status])
    |> validate_inclusion(:status, ["draft", "published", "require_moderation"])
  end

  defp update_attrs(attrs) do
    if attrs["status"] == "published" do
      Map.put(attrs, "published_at", DateTime.utc_now)
    else
      attrs
    end
  end
end
