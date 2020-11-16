defmodule Blog.Categorizer.Services.BuildIndex do
  alias Blog.Repo
  alias Blog.Datasets.Categories.Category

  def call do
    Enum.reduce(Repo.all(Category), %{}, fn cat, index -> add_to_index(cat, index) end) 
  end

  defp add_to_index(cat, index) do
    Enum.reduce(cat.keywords, index, fn keyword, updated_index ->
      Map.put_new(updated_index, keyword, [])
      Map.put(updated_index, keyword, [cat.id | updated_index[keyword]])
    end)
  end
end
