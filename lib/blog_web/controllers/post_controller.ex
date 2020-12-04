defmodule BlogWeb.PostController do
  use BlogWeb, :controller

  alias Blog.Datasets.Posts
  alias Blog.Datasets.Posts.Post
  alias Blog.Datasets.Posts.Services
  alias Blog.Categorizer.Server

  action_fallback BlogWeb.FallbackController

  def index(conn, params) do
    posts = Services.FilterPosts.call(params)
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    post_params = Map.put(post_params, "status", "draft")

    with {:ok, %Post{} = post} <- Posts.create_post(post_params) do
      Server.categorize_post(post)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    with {:ok, %Post{} = post} <- Posts.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)

    with {:ok, %Post{}} <- Posts.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
