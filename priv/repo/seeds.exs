# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blog.Repo.insert!(%Blog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Blog.Factory
alias Blog.Datasets.Posts.Post
alias Blog.Repo

Repo.transaction(fn ->
  categories = []

  Enum.each(0..20, fn _i -> 
    categories ++ [Factory.insert!(:category)]
  end)

  Enum.each(0..10, fn _i ->  
    ids = Enum.take_random(categories, 5) |> Enum.map(fn cat -> cat.id end) 
    Factory.insert!(:post)
    |> Post.changeset(%{category_ids: ids})
    |> Repo.update!
  end)
end)
