defmodule Blog.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :text, :string
      add :status, :string, default: "draft"
      add :published_at, :naive_datetime

      timestamps()
    end

  end
end
