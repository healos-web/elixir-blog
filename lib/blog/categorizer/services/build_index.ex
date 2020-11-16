defmodule Blog.Categorizer.Services.BuildIndex do
  alias Blog.Repo
  alias Blog.Datasets.Categories.Category

  def call do
    Enum.reduce(Repo.all(Category), %{}, fn cat, index -> add_to_index(cat, index) end) 
  end

  defp add_to_index(cat, index) do
    Enum.reduce(cat.keywords, index, fn keyword, ind ->
      ind = Map.put_new(ind, keyword, [])
      Map.put(ind, keyword, [cat.id | ind[keyword]])
    end)
  end
end
