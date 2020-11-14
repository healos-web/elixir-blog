defmodule BlogWeb.PostView do
  use BlogWeb, :view
  alias BlogWeb.PostView

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      title: post.title,
      text: post.text,
      status: post.status,
      published_at: post.published_at}
  end
end
