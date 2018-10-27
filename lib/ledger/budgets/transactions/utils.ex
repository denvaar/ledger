defmodule Ledger.Budgets.Transactions.Utils do
  def multiplier("debit"), do: -1
  def multiplier("credit"), do: 1
  def multiplier(_), do: 0
end
