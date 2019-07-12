defmodule BlawgApiWeb.Router do
  use BlawgApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug BlawgApiWeb.Plugs.Authentication
  end

  scope "/api", BlawgApiWeb do
    pipe_through :api

    resources "/articles", ArticleController,
      only: [:create, :update, :delete, :index],
      param: "slug"
  end

  get "/*path", BlawgApiWeb.CorsController, :index
end
