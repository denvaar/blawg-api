defmodule BlawgApiWeb.Router do
  use BlawgApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug BlawgApiWeb.Plugs.Authentication
  end

  scope "/api", BlawgApiWeb do
    pipe_through :api

    post "/articles/create", ArticleController, :create
  end
end
