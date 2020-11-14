defmodule Blog.Datasets.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :description, :string
    field :name, :string
    field :need_moderation, :boolean, default: false
    field :tag, :string
    field :keywords, {:array, :string}

    has_many :posts_categories, Blog.Datasets.PostsCategory
    has_many :posts, through: [:posts_categories, :posts]

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :tag, :description, :need_moderation, :keywords])
    |> validate_required([:name, :tag])
    |> validate_is_not_empty(:keywords)
    |> unique_constraint(:tag)
  end

  def validate_is_not_empty(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, keywords ->
      case Enum.empty?(keywords) do
        false -> []
        true -> [{field, options[:message] || "Put at least one keyword"}]
      end
    end)
  end
end
