defmodule BlogWeb.CategoryController do
  use BlogWeb, :controller

  alias Blog.Datasets.Categories
  alias Blog.Datasets.Categories.Category
  alias Blog.Categorizer.Server

  action_fallback BlogWeb.FallbackController

  def index(conn, _params) do
    categories = Categories.list_categories()
    render(conn, "index.json", categories: categories)
  end

  def create(conn, %{"category" => category_params}) do
    with {:ok, %Category{} = category} <- Categories.create_category(category_params) do
      Server.update_index(:add, %{category: category})
      
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.category_path(conn, :show, category))
      |> render("show.json", category: category)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Categories.get_category!(id)
    render(conn, "show.json", category: category)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Categories.get_category!(id)
    old_category = category

    with {:ok, %Category{} = category} <- Categories.update_category(category, category_params) do
      Server.update_index(:update, %{category: category, old_category: old_category})

      render(conn, "show.json", category: category)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Categories.get_category!(id)

    with {:ok, %Category{}} <- Categories.delete_category(category) do
      Server.update_index(:delete, %{category: category})
      send_resp(conn, :no_content, "")
    end
  end
end
