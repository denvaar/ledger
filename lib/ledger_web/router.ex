defmodule LedgerWeb.Router do
  use LedgerWeb, :router

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

  scope "/", LedgerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/accounts", AccountController
    resources "/transactions", TransactionController
  end

  # Other scopes may use custom stacks.
  # scope "/api", LedgerWeb do
  #   pipe_through :api
  # end
end
