defmodule BlawgApiWeb.CorsController do
  use BlawgApiWeb, :controller

  plug :action

  def index(conn, _data) do
    conn
    |> put_status(:not_found)
    |> json(%{message: "Not Found"})
  end
end
