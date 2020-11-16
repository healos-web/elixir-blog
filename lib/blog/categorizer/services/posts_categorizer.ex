defmodule Blog.Categorizer.Services.PostsCategorizer do
  import Ecto.Query

  alias Blog.Repo
  alias Blog.Datasets.Categories.Category
  alias Blog.Datasets.Posts.Post
  alias Blog.Datasets.PostsCategory
  
  def call(index, post) do
    keywords = Map.keys(index)

    text = prepare_text(post.title <> " " <> post.text)
    words = String.split(text)

    diff = words -- keywords
    matched_keywords = words -- diff

    Repo.transaction(fn ->
      Enum.each(matched_keywords, fn keyword ->
        Enum.each(index[keyword], fn category_id ->
          unless Repo.exists?(from pc in PostsCategory, where: pc.post_id == ^post.id and pc.category_id == ^category_id) do
            Repo.insert(%PostsCategory{post_id: post.id, category_id: category_id})
          end
        end)
      end)

      update_status(post)
    end)

    {:ok}
  end

  defp prepare_text(text) do
    String.replace(String.downcase(text), ~r/(,|\.|\!|\?)/, " ")
  end

  defp update_status(post) do
  end
end
