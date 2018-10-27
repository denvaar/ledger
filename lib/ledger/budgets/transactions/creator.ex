defmodule Ledger.Budgets.Transactions.Creator do
  @moduledoc """
  Creates transactions
  """

  alias Ecto.Multi
  alias Ledger.Repo
  alias Ledger.Budgets.{Account, Transaction}

  import Ledger.Budgets.Transactions.Utils, only: [multiplier: 1]


  def create_transaction(%{"account_id" => account_id, "amount" => _amount, "date" => _date, "description" => _description, "type" => type} = attrs) do
    transaction_changeset = Transaction.changeset(%Transaction{}, attrs)
    account = Ledger.Budgets.get_account!(account_id)
    account_changeset = Account.changeset(account, %{balance: account.balance.amount + (transaction_changeset.changes.amount.amount * multiplier(type))})

    transaction = Multi.new()
      |> Multi.insert(:transaction, transaction_changeset)
      |> Multi.update(:account, account_changeset)

    Repo.transaction(transaction)
  end

  def create_transaction(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end
end
