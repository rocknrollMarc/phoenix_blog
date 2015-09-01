defmodule Blog.Router do
  use Blog.Web, :router


  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Blog.Plug.CSRF
  end

  pipline :auth do
    plug Blog.Plug.Authentication
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # public routes via the api
  scope "/api/v1", alias: Blog do
    pipe_through :api
  end

  # Private routes via the api
  scope "/api/v1", alias: Blog do
    pipe_through[:api, :auth]
  end

  # Public routes via the browser
  scope alias: Blog do
    pipe_through :browser
  end

  # Private routes via the browser
  scope alias: Blog do
    pipe_through[:browser, :auth]
  end

  scope "/", Blog do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Blog do
  #   pipe_through :api
  # end
end
