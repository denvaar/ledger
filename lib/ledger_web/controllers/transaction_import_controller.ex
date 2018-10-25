defmodule LedgerWeb.TransactionImportController do
  use LedgerWeb, :controller

  alias Ledger.Budgets
  alias Ledger.Budgets.Transaction

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"csv_file" => csv_file}) do
    case Budgets.import_transactions(csv_file) do
      {:ok, _transaction} ->
        conn
        |> put_flash(:info, "Transactions imported successfully.")
        |> redirect(to: report_path(conn, :index))
      {:error, :transaction, %Ecto.Changeset{} = changeset, _} ->
        conn
        |> put_flash(:info, "Failed to import transactions.")
        |> render("new.html")
    end
  end
end
