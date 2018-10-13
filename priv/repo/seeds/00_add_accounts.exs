alias Ledger.Budgets.Account

accounts = [
  %{name: "Groceries", type: "expense_account", amount: 300.00},
  %{name: "Restauraunts", type: "expense_account", amount: 80.00},
  %{name: "Home", type: "expense_account", amount: 2100.00},
  %{name: "Auto", type: "expense_account", amount: 200.00},
  %{name: "Bicycles", type: "expense_account", amount: 30.00},
  %{name: "Bob's Allowance", type: "expense_account", amount: 50.00},
  %{name: "Betty's Allowance", type: "expense_account", amount: 50.00},
  %{name: "Vacation & Travel", type: "expense_account", amount: 100.00},
  %{name: "Tithing & Donations", type: "expense_account", amount: 443.00},
  %{name: "Gifts", type: "expense_account", amount: 50.00},
  %{name: "Entertainment", type: "expense_account", amount: 60.00},
  %{name: "Utilities", type: "expense_account", amount: 200.00},
  %{name: "Subscriptions", type: "expense_account", amount: 30.00},
  %{name: "Pet", type: "expense_account", amount: 30.00},
  %{name: "Retirement", type: "savings_account", amount: 300.00},
  %{name: "Discover Bank", type: "savings_account", amount: 500.00},
  %{name: "HSA", type: "savings_account", amount: 50.00},
]

default_account_data = %{
  inserted_at: DateTime.utc_now(),
  updated_at: DateTime.utc_now()
}

accounts = Enum.map(accounts, fn(account_data) ->
  Map.merge(account_data, default_account_data) end)

Ledger.Repo.insert_all(Account, accounts)
