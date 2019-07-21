defmodule BlawgApiWeb.Router do
  use BlawgApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_write do
    plug BlawgApiWeb.Plugs.Authentication
  end

  scope "/api", BlawgApiWeb do
    pipe_through :api

    scope "/" do
      resources "/articles", ArticleController,
        only: [:show],
        param: "slug"
    end

    scope "/" do
      pipe_through :api_write

      resources "/articles", ArticleController,
        only: [:create, :update, :delete, :index],
        param: "slug"
    end
  end

  get "/*path", BlawgApiWeb.CorsController, :index
end
