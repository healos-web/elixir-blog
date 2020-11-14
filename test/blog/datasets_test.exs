defmodule Blog.DatasetsTest do
  use Blog.DataCase

  alias Blog.Datasets

  describe "categories" do
    alias Blog.Datasets.Category

    @valid_attrs %{description: "some description", name: "some name", need_moderation: true, tag: "some tag", keywords: ["some_keyword"]}
    @update_attrs %{description: "some updated description", name: "some updated name", need_moderation: false, tag: "some updated tag", keywords: ["some_updated_keyword"]}
    @invalid_attrs %{name: nil, tag: nil, keywords: []}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Datasets.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Datasets.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Datasets.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Datasets.create_category(@valid_attrs)
      assert category.description == "some description"
      assert category.name == "some name"
      assert category.need_moderation == true
      assert category.tag == "some tag"
      assert category.keywords == ["some_keyword"]
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Datasets.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Datasets.update_category(category, @update_attrs)
      assert category.description == "some updated description"
      assert category.name == "some updated name"
      assert category.need_moderation == false
      assert category.tag == "some updated tag"
      assert category.keywords == ["some_updated_keyword"]
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Datasets.update_category(category, @invalid_attrs)
      assert category == Datasets.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Datasets.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Datasets.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Datasets.change_category(category)
    end
  end
end
