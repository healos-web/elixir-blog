defmodule Blog.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :tag, :string
      add :description, :string
      add :need_moderation, :boolean, default: false, null: false
      add :keywords, {:array, :string}

      timestamps()
    end

  end
end
