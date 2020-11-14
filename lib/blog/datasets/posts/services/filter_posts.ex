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
      fn filter, acc_query -> apply_filter(acc_query, filter, params[filter]) end
    ) 
  end

  defp apply_filter(query, filter, value) do
    case filter do
      "title" ->
        from(p in query, where: ilike(p.title, ^"%#{value}%"))
      "status" ->
        from(p in query, where: p.status == ^value)
      "created_at_from" ->
        from(p in query, where: p.inserted_at >= ^value)
      "created_at_to" ->
        from(p in query, where: p.inserted_at < ^value)
      _ ->
        query
    end
  end
end
