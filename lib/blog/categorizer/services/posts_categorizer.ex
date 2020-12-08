defmodule Blog.Categorizer.Services.PostsCategorizer do
  import Ecto.Query

  alias Blog.Repo
  alias Blog.Datasets.Posts.Post
  alias Blog.Datasets.Posts
  alias Blog.Datasets.PostsCategories.PostsCategory
  
  def call(index, post) do
    keywords = Map.keys(index)

    words = prepare_text(post.title <> " " <> post.text)
    |> String.split

    diff = words -- keywords
    matched_keywords = words -- diff

    Repo.transaction(fn ->
      connect_categories(index, matched_keywords, post)
      update_status(post)
    end)

    {:ok}
  end

  defp prepare_text(text) do
    text
    |> String.downcase
    |> String.replace(~r/(,|\.|\!|\?|\"|\')/, " ")
  end

  defp connect_categories(index, matched_keywords, post) do
    Enum.each(matched_keywords, fn keyword ->
      Enum.each(index[keyword], fn category_id ->
        connect_category(category_id, post)
      end)
    end)
  end

  defp connect_category(category_id, post) do
    unless Repo.exists?(from pc in PostsCategory, where: pc.post_id == ^post.id and pc.category_id == ^category_id) do
      Repo.insert(%PostsCategory{post_id: post.id, category_id: category_id})
    end
  end

  defp update_status(post) do
    need_moderation_category = (
      (from cat in Ecto.assoc(post, :categories), where: cat.need_moderation == true)
      |> Repo.one
    )

    if need_moderation_category do
      Post.changeset(post, %{status: "require_moderation"})
      |> Repo.update
    else
      Posts.publish(post)
    end
  end
end
