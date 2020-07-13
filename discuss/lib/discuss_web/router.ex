defmodule DiscussWeb.Router do
  use DiscussWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DiscussWeb.Plugs.SetUser
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", DiscussWeb do
    pipe_through :browser

    resources "/topics", TopicController

    get "/", TopicController, :index
    # get "/topics/:id", TopicController, :show
    # get "/topics/new", TopicController, :new
    # get "topics/:id/edit", TopicController, :edit
    # post "topics", TopicController, :create
    # put "topics/:id", TopicController, :update
    # delete "topics/:id", TopicController, :delete
  end

  scope "/auth", DiscussWeb do
    pipe_through :browser

    delete "/signout", AuthController, :signout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", DiscussWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: DiscussWeb.Telemetry)
    end
  end
end
