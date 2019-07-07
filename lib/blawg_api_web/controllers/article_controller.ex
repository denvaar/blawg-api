defmodule BlawgApiWeb.ArticleController do
  use BlawgApiWeb, :controller

  alias BlawgApi.Persistance

  def index(conn, _params) do
    articles =
      Persistance.list_articles()
      |> Enum.map(fn(article) ->
        Map.from_struct(article)
      end)

    conn
    |> put_status(:ok)
    |> render("index.json", articles: articles)
  end

  def create(conn, params) do
    with {:ok, %{slug: slug}} <- Persistance.create_article(params) do
      conn
      |> put_status(:created)
      |> render("show.json", article: %{slug: slug})
    else
      {:error, errors} ->
        conn
        |> put_status(400)
        |> json(%{errors: errors})
    end
  end

  def update(conn, %{"slug" => slug, "article" => article} = _params) do
    with {:ok, %{slug: slug}} <- Persistance.update_article(slug, article) do
      conn
      |> put_status(204)
      |> render("show.json", article: %{slug: slug})
    else
      {:error, errors} ->
        conn
        |> put_status(400)
        |> json(%{errors: errors})
      :not_found ->
        conn
        |> put_status(404)
        |> json(%{errors: ["article not found"]})
    end
  end

  def delete(conn, %{"slug" => slug}) when is_binary(slug) do
    with :ok <- Persistance.delete_article(slug) do
      conn
      |> put_status(200)
      |> render("show.json", article: %{slug: slug})
    else
      :not_found ->
        conn
        |> put_status(404)
        |> json(%{errors: ["article not found"]})
    end
  end
end
