defmodule Blog.Categorizer.Services.UpdateIndex do  
  def call(index, %{old_category: old_category, category: category, update_type: update_type}) do
    case update_type do
      "delete" ->
        delete_category_from_index(index, category)
      "add" ->
        add_category_to_index(index, category)
      "update" ->
        update_category_in_index(index, old_category, category)
      _ ->
        index
    end      
  end

  defp add_category_to_index(index, category) do
    add_to_keywords(index, category.keywords, category.id)
  end

  defp delete_category_from_index(index, category) do
    delete_from_keywords(index, category.keywords, category.id)
  end

  defp update_category_in_index(index, old_category, category) do
    keywords_to_delete = old_category.keywords -- category.keywords
    keywords_to_add = category.keywords -- old_category.keywords

    new_index = add_to_keywords(index, keywords_to_add, category.id)
    delete_from_keywords(new_index, keywords_to_delete, category.id)
  end

  defp add_to_keywords(index, keywords, value) do
    Enum.reduce(keywords, index, fn keyword, ind ->
      Map.put_new(ind, keyword, [])
      Map.put(ind, keyword, [value | ind[keyword]])
    end)
  end

  defp delete_from_keywords(index, keywords, value) do
    Enum.reduce(keywords, index, fn keyword, ind ->
      Map.put(ind, keyword, List.delete(ind[keyword], value))
    end)
  end
end
