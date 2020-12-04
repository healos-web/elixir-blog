defmodule Blog.Categorizer.Services.BuildIndex do
  alias Blog.Datasets.Categories

  def call do
    categories = Categories.list_categories
    
    categories
    |> Enum.reduce(%{}, fn cat, index -> add_to_index(cat, index) end)
  end

  defp add_to_index(cat, index) do
    cat.keywords
    |> Enum.reduce(index, fn keyword, ind ->
      Map.put_new(ind, keyword, [])
      |> Map.put(keyword, [cat.id | ind[keyword]])
    end)
  end
end
