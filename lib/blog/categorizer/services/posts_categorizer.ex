defmodule Blog.Categorizer.Services.PostsCategorizer do
  alias Blog.Repo
  alias Blog.Datasets.Categories.Category
  alias Blog.Datasets.Posts.Post
  alias Blog.Datasets.PostsCategory
  
  def call(index, post) do
    keywords = Map.keys(index)

    text = prepare_text(post.title <> " " <> post.text)
    words = String.split(text)

    diff = words - keywords
    matched_keywords = words - diff

    Repo.transaction(fn ->
      Enum.each(matched_keywords, fn keyword ->
        Enum.each(index[keyword], fn category_id ->
          Repo.insert(%PostsCategory{post_id: post.id, category_id: category_id})
        end)
      end)
    end)

    {:ok}
  end

  defp prepare_text(text) do
    String.replace(String.downcase(text), ~r/(,|\.|\!|\?)/, "")
  end
end
