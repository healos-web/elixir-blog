defmodule Blog.Repo.Migrations.AddUniqueIndexToTags do
  use Ecto.Migration

  def change do
    create unique_index(:categories, [:tag])
  end
end
