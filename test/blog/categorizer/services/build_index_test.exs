defmodule Blog.Categorizer.Services.BuildIndexTest do
  use Blog.DataCase
  alias Blog.Categorizer.Services.BuildIndex

  describe "call" do
    test "builds correct index" do
      category_1 = Blog.Factory.insert!(:category)
      category_2 = Blog.Factory.insert!(:category)

      index = BuildIndex.call

      Enum.each(category_1.keywords, fn keyword ->
        assert Enum.member?(index[keyword], category_1.id) == true
      end)

      Enum.each(category_2.keywords, fn keyword ->
        assert Enum.member?(index[keyword], category_2.id) == true
      end)
    end
  end
end
