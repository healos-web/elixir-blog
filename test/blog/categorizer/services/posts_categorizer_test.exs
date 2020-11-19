defmodule Blog.Categorizer.Services.PostsCategorizerTest do
  use Blog.DataCase
  alias Blog.Datasets.PostsCategories.PostsCategory
  alias Blog.Categorizer.Services.PostsCategorizer
  alias Blog.Repo

  describe "call" do
    setup do
      category_1 = Blog.Factory.insert!(:category, keywords: ["best", "cool"])
      category_2 = Blog.Factory.insert!(:category, keywords: ["cool", "test"])
      category_3 = Blog.Factory.insert!(:category, keywords: ["no", "match"])
      post = Blog.Factory.insert!(:post, text: "Best, cool, post ever", title: "That's a test post")
      
      {:ok, index: %{
        "no" => [category_3.id],
        "match" => [category_3.id],
        "best" => [category_1.id],
        "cool" => [category_1.id, category_2.id],
        "test" => [category_2.id]
        }, post: post, category_1: category_1, category_2: category_2, category_3: category_3 }
    end
    
    
    test "creates categories for post", %{index: index, post: post, category_1: category_1, category_2: category_2, category_3: category_3} do
      result = PostsCategorizer.call(index, post)

      assert result == {:ok}
      assert Repo.one(from p in PostsCategory, select: count(p.id)) == 2

      post_categories = Ecto.assoc(post, :categories) |> Repo.all
      assert Enum.member?(post_categories, category_1) == true
      assert Enum.member?(post_categories, category_2) == true
      assert Enum.member?(post_categories, category_3) == false
    end

    test "updates post status", %{index: index, post: post} do
      PostsCategorizer.call(index, post)

      assert Repo.reload(post).status == "published"
      assert Repo.reload(post).published_at != nil
    end

    test "updates status to require moderation when at least one category needs moderation", %{index: index, post: post} do
      category = Blog.Factory.insert!(:category, keywords: ["cool"], need_moderation: true)
      index = Map.put(index, "cool", [category.id | index["cool"]])

      PostsCategorizer.call(index, post)

      assert Enum.member?(Ecto.assoc(post, :categories) |> Repo.all, category) == true
      assert Repo.reload(post).status == "require_moderation"
      assert Repo.reload(post).published_at == nil
    end
  end
end
