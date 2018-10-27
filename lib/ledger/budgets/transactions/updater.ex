defmodule Ledger.Budgets.Transactions.Updater do
  @moduledoc """
  Updates transactions
  """

  alias Ecto.Multi
  alias Ledger.Repo
  alias Ledger.Budgets.{Account, Transaction}

  import Ledger.Budgets.Transactions.Utils, only: [multiplier: 1]


  def update_transaction(%Transaction{} = transaction, %{"account_id" => account_id, "amount" => new_amount, "type" => new_type} = attrs) do

    account_id = String.to_integer(account_id)
    if transaction.account_id == account_id do
      handle_update_same_account(transaction, attrs)
    else
      handle_update_different_account(transaction, attrs)
    end
  end

  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  defp handle_update_same_account(transaction, %{"type" => new_type, "amount" => new_amount} = attrs) do
    account_balance = recalc_account_balances(
      transaction.account.balance.amount,
      transaction.type,
      transaction.amount.amount,
      new_type,
      Money.parse!(new_amount).amount
    )

    account_changeset = Account.changeset(transaction.account, %{balance: account_balance})
    transaction_changeset = Transaction.changeset(transaction, attrs)

    Multi.new()
    |> Multi.update(:account, account_changeset)
    |> Multi.update(:transaction, transaction_changeset)
    |> Repo.transaction()
  end

  defp handle_update_different_account(transaction, %{"account_id" => account_id, "type" => new_type, "amount" => new_amount} = attrs) do
    new_account = Ledger.Budgets.get_account!(account_id)

    {previous_account_balance, current_account_balance} = recalculate_account_balances(
      transaction.account, transaction.amount.amount, transaction.type,
      new_account, Money.parse!(new_amount).amount, new_type
    )
    transaction_changeset = Transaction.changeset(transaction, attrs)
    previous_account_changeset = Account.changeset(transaction.account, %{balance: previous_account_balance})
    current_account_changeset = Account.changeset(new_account, %{balance: current_account_balance})
    Multi.new()
    |> Multi.update(:previous_account, previous_account_changeset)
    |> Multi.update(:transaction, transaction_changeset)
    |> Multi.update(:current_account, current_account_changeset)
    |> Repo.transaction()
  end

  defp recalculate_account_balances(old_account, old_amount, old_type,
                                   new_account, new_amount, new_type) do
    old_account_balance = old_account.balance.amount + (old_amount * -1 * multiplier(old_type))
    new_account_balance = new_account.balance.amount + (new_amount * multiplier(new_type))

    {old_account_balance, new_account_balance}
  end

  defp recalc_account_balances(balance, from_type, from_amount, to_type, to_amount) do
    diff = (from_amount * -1 * multiplier(from_type)) + (to_amount * multiplier(to_type))
    balance + diff
  end
end
