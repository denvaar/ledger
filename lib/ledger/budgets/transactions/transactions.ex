defmodule Ledger.Budgets.Transactions do
  @moduledoc """
  Transaction specific function for the budgets context
  """

  import Ecto.Query, only: [from: 2]

  alias Ledger.Repo
  alias Ledger.Budgets.{Category, Transaction}


  def list_transactions do
    from(t in Transaction, preload: [:account, :category])
  end

  def get_transaction!(id) do
    from(t in Transaction, where: t.id == ^id, preload: :account)
    |> Repo.get!(id)
  end

  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end

  def monthly_savings(date \\ Date.utc_today()) do
    query = from(t in transactions_this_month_query(Date.utc_today()), where: t.type == "credit", select: sum(t.amount))

    Repo.one(query) || 0
  end

  def monthly_expenses(date \\ Date.utc_today()) do
    query = from(t in transactions_this_month_query(date),
                                                    where: t.type == "debit",
                                                    select: sum(t.amount))
    Repo.one(query) || 0
  end

  def amounts_by_budget() do
    query = from(t in transactions_this_month_query(Date.utc_today()),
         where: t.type == "debit",
         left_join: c in Category, on: c.id == t.category_id,
         select: {c.name, sum(t.amount)},
         group_by: c.name)
    Repo.all(query)
  end

  defp transactions_this_month_query(date) do
    last_day_of_month = %{date | day: Date.days_in_month(date)}
    first_day_of_month = %{date | day: 1}

    from(t in Transaction,
         where: t.date >= ^first_day_of_month and t.date <= ^last_day_of_month)
  end
end
