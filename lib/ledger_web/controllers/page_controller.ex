defmodule LedgerWeb.PageController do
  use LedgerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
