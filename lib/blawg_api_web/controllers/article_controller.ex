defmodule BlawgApiWeb.ArticleController do
  use BlawgApiWeb, :controller

  def create(conn, _data) do
    conn
    |> put_status(:created)
    |> json(%{})
  end
end
