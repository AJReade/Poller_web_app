defmodule PollerPhxWeb.Router do
  use PollerPhxWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(PollerPhxWeb.Plugs.Auth)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:fetch_session)
    plug(PollerPhxWeb.Plugs.Auth)
  end

  scope "/", PollerPhxWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/auth", PollerPhxWeb do
    pipe_through(:browser)

    get("/login", AuthController, :new)
    post("/login", AuthController, :create)
    delete("/logout", AuthController, :delete)
  end

  scope "/areas", PollerPhxWeb do
    pipe_through([:browser, :valid_user, :admin_user])

    resources("/", AreaController, except: [:show])
    resources("/:area_id/questions", QuestionController, except: [:show])
    resources("/:area_id/questions/:question_id/choices", ChoiceController, except: [:show])
  end

  # Other scopes may use custom stacks.
  scope "/api", PollerPhxWeb.Api do
    pipe_through(:api)

    get("/areas", AreaController, :index)
    get("/areas/:area_id", AreaController, :show)
    get("/areas/:area_id/questions", QuestionController, :index)
    get("/questions/:question_id/choices", ChoiceController, :index)
  end

  scope "/api", PollerPhxWeb.Api do
    pipe_through([:api, :valid_user])

    put("/areas/:area_id/choices/:choice_id", ChoiceController, :vote)
  end

  scope "/app", PollerPhxWeb do
    pipe_through(:browser)

    get("/*path", AppController, :index)
  end
end
