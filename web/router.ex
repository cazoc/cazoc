defmodule Cazoc.Router do
  use Cazoc.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Cazoc do
    pipe_through :browser # Use the default browser stack

    get "/", TopController, :index
    get "/page", PageController, :index

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete

    get  "/new", MyArticleController, :new
    post "/new", MyArticleController, :create
    get  "/:name/articles", MyArticleController, :index
    get "/articles/:id", ArticleController, :show
    get  "/edit/:id", MyArticleController, :edit
    post "/update/:id", MyArticleController, :update
    delete "/delete/:id", MyArticleController, :delete

    get  "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
  end

  scope "/admin", Cazoc do
    pipe_through :browser

    get "/", AdminController, :index

    resources "/authors", AuthorController
    resources "/repositories", RepositoryController
    resources "/articles", ArticleController
    resources "/comments", CommentController
    resources "/services", ServiceController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Cazoc do
  #   pipe_through :api
  # end
end
