defmodule Cazoc.Router do
  use Cazoc.Web, :router
  use ExAdmin.Router
  require Ueberauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
  end

  scope "/auth", Cazoc do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # setup the ExAdmin routes
  scope "/admin", ExAdmin do
    pipe_through :browser
    admin_routes
  end

  scope "/", Cazoc do
    pipe_through :browser # Use the default browser stack

    get "/", TopController, :index

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete

    get  "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    get  "/github", GithubController, :index
    post "/github", GithubController, :import
    delete "/github", GithubController, :delete

    get  "/search", SearchController, :index
  end

  scope "/", Cazoc do
    pipe_through :browser # Use the default browser stack

    resources "/authors", AuthorController
    resources "/articles", MyArticleController, except: [:show]
    get  "/articles/:uuid", MyArticleController, :show
    resources "/collaborators", CollaboratorController
    resources "/comments", CommentController
    resources "/families", MyFamilyController, except: [:show]
    get  "/:author/:name", MyFamilyController, :show
    resources "/repositories", RepositoryController
    resources "/services", ServiceController
  end

  scope "/api", Cazoc do
    pipe_through :api

    scope "/v1", as: :v1 do
      resources "/authors", AuthorController, only: [:index, :show]
      resources "/repositories", RepositoryController, only: [:index, :show]
      resources "/articles", MyArticleController, only: [:index, :show]
      resources "/comments", CommentController, only: [:index, :show]
      resources "/families", MyFamilyController, only: [:index, :show]
      resources "/collaborators", CollaboratorController, only: [:index, :show]
    end
  end
end
