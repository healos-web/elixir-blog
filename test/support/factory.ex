defmodule Blog.Factory do
  alias Blog.Repo
  alias Blog.Datasets.Posts.Post
  alias Blog.Datasets.Categories.Category

  def build(:post) do
    %Post{
      title: Faker.Beer.brand(),
      text: Faker.Lorem.paragraph(1)
    }
  end

  def build(:category) do
    %Category{
      tag: Faker.UUID.v4(),
      description: Faker.Lorem.paragraph(1),
      name: Faker.Lorem.word(),
      keywords: Faker.Lorem.words(2..5)
    }
  end

  def build(:need_moderation_category) do
    %{ build(:category) | need_moderation: true }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
