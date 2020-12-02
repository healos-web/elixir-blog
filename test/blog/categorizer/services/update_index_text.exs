defmodule Blog.Categorizer.Services.BuildIndexTest do
  use Blog.DataCase
  alias Blog.Datasets.Categories.Category
  alias Blog.Categorizer.Services.UpdateIndex

  describe "call (index, %{category: category, update_type: \"add\"" do
    setup do
      {:ok, index: %{}}
    end
    
    test "adds new category to index", context do
      new_category = Blog.Factory.insert!(:category)
      index = UpdateIndex.call(:add, context[:index], %{category: new_category})

      Enum.each(new_category.keywords, fn keyword ->
        assert Enum.member?(index[keyword], new_category.id) == true
      end)
    end
  end

  describe "call (index, %{old_category: old_category, category: category, update_type: \"update\"}" do
    setup do
      category = Blog.Factory.insert!(:category, keywords: ["old"])

      {:ok, index: %{"old" => [category.id]}, category: category}
    end
    
    test "adds new category to index", %{index: index, category: category} do
      {:ok, updated_category} = Category.changeset(category, %{keywords: ["new"]}) |> Repo.update
      updated_index = UpdateIndex.call(:update, index, %{category: category, old_category: updated_category})

      assert Enum.member?(updated_index["old"], category.id) == false
      assert Enum.member?(updated_index["new"], category.id) == true
    end
  end

  describe "call (index, %{category: category, update_type: \"delete\"" do
    setup do
      category = Blog.Factory.insert!(:category, keywords: ["test", "test-2"])

      {:ok, index: %{"test" => [category.id], "test-2" => [category.id]}, category: category}
    end
    
    test "adds new category to index", %{index: index, category: category} do
      updated_index = UpdateIndex.call(:delete, index, %{category: category})

      Enum.each(category.keywords, fn keyword ->
        assert Enum.member?(updated_index[keyword], category.id) == false
      end)
    end
  end
end
