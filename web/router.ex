defmodule DevNotex.Router do
  use DevNotex.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticated do
    plug DevNotex.Authentication.TokenPlug, repo: DevNotex.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug
  end

  scope "/", DevNotex do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", DevNotex.Api do
    pipe_through :api

    post "/users", UserController, :create
  end

  scope "/api", DevNotex.Api  do
    pipe_through :api
    pipe_through :authenticated

    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", DevNotex do
  #   pipe_through :api
  # end
end
