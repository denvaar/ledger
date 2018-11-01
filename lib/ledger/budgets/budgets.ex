defmodule Ledger.Budgets do
  @moduledoc """
  The Budgets context.
  """

  alias Ledger.Budgets.{Categories, Accounts, Transactions}

  defdelegate category_options, to: Categories
  defdelegate change_category(category), to: Categories
  defdelegate create_category(attrs), to: Categories
  defdelegate get_category!(id), to: Categories
  defdelegate list_categories, to: Categories
  defdelegate update_category(category, attrs), to: Categories

  defdelegate account_options, to: Accounts
  defdelegate change_account(account), to: Accounts
  defdelegate create_account(attrs), to: Accounts
  defdelegate delete_account(account), to: Accounts
  defdelegate get_account!(id), to: Accounts
  defdelegate get_account(id), to: Accounts
  defdelegate list_accounts, to: Accounts
  defdelegate update_account(account, attrs), to: Accounts
  defdelegate total_balance, to: Accounts

  defdelegate amounts_by_budget(), to: Transactions
  defdelegate change_transaction(transaction), to: Transactions
  defdelegate create_transaction(attrs), to: Transactions.Creator
  defdelegate delete_transaction(transaction), to: Transactions
  defdelegate get_transaction!(id), to: Transactions
  defdelegate import_transactions(csv_file), to: Transactions.Importer
  defdelegate list_transactions, to: Transactions
  defdelegate monthly_expenses, to: Transactions
  defdelegate monthly_expenses(date), to: Transactions
  defdelegate monthly_savings, to: Transactions
  defdelegate monthly_savings(date), to: Transactions
  defdelegate update_transaction(transaction, attrs), to: Transactions.Updater
end
