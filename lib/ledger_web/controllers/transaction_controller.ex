defmodule LedgerWeb.TransactionController do
  use LedgerWeb, :controller

  alias Ledger.Budgets
  alias Ledger.Budgets.Transaction

  def index(conn, params) do
    page =
      Budgets.list_transactions()
      |> Ledger.Repo.paginate(params)

    render(conn, "index.html", page: page)
  end

  def new(conn, _params) do
    categories = Budgets.category_options()
    accounts = Budgets.account_options()
    changeset = Budgets.change_transaction(%Transaction{})
    render(conn, "new.html", accounts: accounts, categories: categories, changeset: changeset)
  end

  def create(conn, %{"transaction" => transaction_params}) do
    case Budgets.create_transaction(transaction_params) do
      {:ok, _transaction} ->
        conn
        |> put_flash(:info, "Transaction created successfully.")
        |> redirect(to: transaction_path(conn, :index))
      {:error, :transaction, %Ecto.Changeset{} = changeset, _} ->
        categories = Budgets.category_options()
        accounts = Budgets.account_options()
        render(conn, "new.html", categories: categories, accounts: accounts, changeset: changeset)
      {:error, %Ecto.Changeset{} = changeset} ->
        categories = Budgets.category_options()
        accounts = Budgets.account_options()
        render(conn, "new.html", categories: categories, accounts: accounts, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    transaction = Budgets.get_transaction!(id)
    accounts = Budgets.account_options()
    categories = Budgets.category_options()
    changeset = Budgets.change_transaction(transaction)
    render(conn, "edit.html", transaction: transaction, accounts: accounts, categories: categories, changeset: changeset)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Budgets.get_transaction!(id)

    case Budgets.update_transaction(transaction, transaction_params) do
      {:ok, _transaction} ->
        conn
        |> put_flash(:info, "Transaction updated successfully.")
        |> redirect(to: transaction_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        categories = Budgets.category_options()
        accounts = Budgets.account_options()
        render(conn, "edit.html", categories: categories, accounts: accounts, transaction: transaction, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Budgets.get_transaction!(id)
    {:ok, _transaction} = Budgets.delete_transaction(transaction)

    conn
    |> put_flash(:info, "Transaction deleted successfully.")
    |> redirect(to: transaction_path(conn, :index))
  end
end
