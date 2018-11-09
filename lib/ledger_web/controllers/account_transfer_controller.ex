defmodule LedgerWeb.AccountTransferController do
  use LedgerWeb, :controller

  alias Ledger.Budgets

  def new(conn, _params) do
    accounts =
      Budgets.list_accounts()
      |> Enum.map(&{"#{&1.name} (#{&1.balance})", &1.id})

    render(conn, "new.html", accounts: accounts)
  end

  def create(conn, %{"from_account" => from_account,
                     "to_account" => to_account,
                     "amount" => amount}) do
    case Budgets.transfer_funds(from_account, to_account, amount) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Money transfer successful.")
        |> redirect(to: account_path(conn, :index))
      _ ->
        conn
        |> put_flash(:info, "There was a problem with the transfer.")
        |> render("new.html", accounts: accounts)
    end
  end

  defp accounts do
    Budgets.list_accounts()
    |> Enum.map(&{"#{&1.name} (#{&1.balance})", &1.id})
  end
end
