defmodule Blog.Datasets.Posts.Services.FilterPosts do
  import Ecto.Query
  alias Blog.Repo
  alias Blog.Datasets.Posts.Post
  
  def call(params) do
    from(p in Post)
    |> apply_filters(params)
    |> Repo.all
  end

  defp apply_filters(query, params) do
    Enum.reduce(
      Map.keys(params),
      query,
      fn filter, acc_query -> apply_filter(acc_query, params[filter], %{filter: filter}) end
    )
  end

  defp apply_filter(query, value, %{filter: "title"}) do
    from(p in query, where: ilike(p.title, ^"%#{value}%"))
  end

  defp apply_filter(query, value, %{filter: "status"}) do
    from(p in query, where: p.status == ^value)
  end

  defp apply_filter(query, value, %{filter: "category_ids"}) do
    from(p in query,
         join: cat in assoc(p, :categories),
         where: cat.id in ^value)
  end
  
  defp apply_filter(query, value, %{filter: "created_at_from"}) do
    from(p in query, where: p.inserted_at >= ^value)
  end


  defp apply_filter(query, value, %{filter: "created_at_to"}) do
    from(p in query, where: p.inserted_at < ^value)
  end

  defp apply_filter(query, _value, _filter) do
    query
  end
end
