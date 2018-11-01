defmodule Ledger.Budgets.Accounts do
  @defmodule """
  Account specific functions for the budgets context
  """

  import Ecto.Query, only: [from: 2]

  alias Ledger.Repo
  alias Ledger.Budgets.Account

  def list_accounts do
    Repo.all(Account)
  end

  def account_options do
    from(account in Account, select: {account.name, account.id})
    |> Repo.all()
  end

  def get_account!(id), do: Repo.get!(Account, id)

  def get_account(id), do: Repo.get(Account, id)

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  def total_balance() do
    from(a in Account, select: sum(a.balance))
    |> Repo.one() || 0
  end
end
