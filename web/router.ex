defmodule Cazoc.Router do
  use Cazoc.Web, :router
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
  end

  scope "/", Cazoc do
    pipe_through :browser # Use the default browser stack

    get "/", TopController, :index

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete

    get  "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
  end

  scope "/", Cazoc do
    pipe_through :browser # Use the default browser stack

    get  "/articles", MyArticleController, :index
    get  "/edit/:id", MyArticleController, :edit
    get  "/write", MyArticleController, :new
    post "/write", MyArticleController, :create
    get  "/articles/:id", MyArticleController, :show
    patch "/update/:id", MyArticleController, :update
    put "/update/:id", MyArticleController, :update
    delete "/delete/:id", MyArticleController, :delete

    get  "/search", SearchController, :index

    get  "/github", GithubController, :index
    #post "/github", GithubController, :import
    post "/github", GithubController, :sync
    delete "/github", GithubController, :delete
  end

  scope "/auth", Cazoc do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  scope "/admin", Cazoc do
    pipe_through :browser

    get "/", AdminController, :index
    resources "/authors", AuthorController
    resources "/repositories", RepositoryController
    resources "/articles", ArticleController
    resources "/comments", CommentController
    resources "/services", ServiceController
    resources "/families", FamilyController
    resources "/collaborators", CollaboratorController
  end

  scope "/api", Cazoc do
    pipe_through :api

    scope "/v1", as: :v1 do
      resources "/authors", AuthorController, only: [:index, :show]
      resources "/repositories", RepositoryController, only: [:index, :show]
      resources "/articles", ArticleController, only: [:index, :show]
      resources "/comments", CommentController, only: [:index, :show]
      resources "/families", FamilyController, only: [:index, :show]
      resources "/collaborators", CollaboratorController, only: [:index, :show]
    end
  end
end
