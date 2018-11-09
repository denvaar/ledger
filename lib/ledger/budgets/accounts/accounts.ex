defmodule Ledger.Budgets.Accounts do
  @defmodule """
  Account specific functions for the budgets context
  """

  alias Ecto.Multi
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

  def transfer_funds(from_id, to_id, amount) do
    from_account =
      from(account in Account,
         where: account.id == ^from_id)
      |> Repo.one()

    to_account =
      from(account in Account,
           where: account.id == ^to_id)
      |> Repo.one()

    with {:ok, money_amount} <- Money.parse(amount) do
      amount = money_amount.amount
      from_changeset = Account.changeset(
        from_account, %{balance: from_account.balance.amount + amount * -1})
      to_changeset = Account.changeset(
        to_account, %{balance: to_account.balance.amount + amount})

      Multi.new()
      |> Multi.update(:from_account, from_changeset)
      |> Multi.update(:to_account, to_changeset)
      |> Repo.transaction()
    else
      _ -> {:error, "Invalid amount"}
    end
  end
end
