alias Ledger.Budgets.Account

accounts = [
  %{name: "Retirement", type: "savings_account", balance: 30000},
  %{name: "Zions Simple Checking", type: "savings_account", balance: 30000},
  %{name: "Discover Bank", type: "savings_account", balance: 50000},
  %{name: "HSA", type: "savings_account", balance: 5000},
]

default_account_data = %{
  inserted_at: DateTime.utc_now(),
  updated_at: DateTime.utc_now()
}

accounts = Enum.map(accounts, fn(account_data) ->
  Map.merge(account_data, default_account_data) end)

Ledger.Repo.insert_all(Account, accounts)
