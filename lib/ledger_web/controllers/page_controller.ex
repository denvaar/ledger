defmodule LedgerWeb.PageController do
  use LedgerWeb, :controller

  def index(conn, _params) do
    current_month = Timex.month_name(Date.utc_today().month)
    savings_amount = Ledger.Budgets.monthly_savings()
    expense_amount = Ledger.Budgets.monthly_expenses()
    total_balance = Ledger.Budgets.total_balance()
    amounts_by_budget = Ledger.Budgets.amounts_by_budget()

    render(conn, "index.html", total_balance: total_balance, current_month: current_month, savings_amount: savings_amount, expense_amount: expense_amount, amounts_by_budget: amounts_by_budget)
  end
end
