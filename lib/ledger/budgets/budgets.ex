defmodule Ledger.Budgets do
  @moduledoc """
  The Budgets context.
  """

  import Ecto.Query, warn: false
  alias Ledger.Repo

  alias Ledger.Budgets.Account


  alias Ledger.Budgets.Category

  @doc """
  Return the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]
  """
  def list_categories do
    Repo.all(Category)
  end

  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def get_category!(id) do
    Repo.get!(Category, id)
  end

  def category_options do
    Repo.all(from(category in Category, select: {category.name, category.id}))
  end

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  def account_options do
    Repo.all(from(account in Account, select: {account.name, account.id}))
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  alias Ledger.Budgets.Transaction

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Transaction
    |> preload([:account, :category])
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id) do
    Repo.get!(Transaction, id)
    |> Repo.preload([:account])
  end

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  alias Ecto.Multi

  defp multiplier("debit"), do: -1
  defp multiplier("credit"), do: 1
  defp multiplier(_), do: 0

  def create_transaction(%{"account_id" => account_id, "amount" => _amount, "date" => _date, "description" => _description, "type" => type} = attrs) do
    transaction_changeset = Transaction.changeset(%Transaction{}, attrs)
    account = get_account!(account_id)
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

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

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

  def handle_update_different_account(transaction, %{"account_id" => account_id, "type" => new_type, "amount" => new_amount} = attrs) do
    new_account = get_account!(account_id)

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

  def recalculate_account_balances(old_account, old_amount, old_type,
                                   new_account, new_amount, new_type) do
    old_account_balance = old_account.balance.amount + (old_amount * -1 * multiplier(old_type))
    new_account_balance = new_account.balance.amount + (new_amount * multiplier(new_type))

    {old_account_balance, new_account_balance}
  end

  # When the account doesn't change
  def recalc_account_balances(balance, from_type, from_amount, to_type, to_amount) do
    diff = (from_amount * -1 * multiplier(from_type)) + (to_amount * multiplier(to_type))
    balance + diff
  end

  @doc """
  Deletes a Transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end

  def total_balance() do
    Repo.one(from(a in Account, select: sum(a.balance))) || 0
  end

  def monthly_savings(date \\ Date.utc_today()) do
    query = from(t in transactions_this_month_query(Date.utc_today()), where: t.type == "credit", select: sum(t.amount))

    Repo.one(query) || 0
  end

  defp transactions_this_month_query(date) do
    last_day_of_month = %{date | day: Date.days_in_month(date)}
    first_day_of_month = %{date | day: 1}

    from(t in Transaction, where: t.date >= ^first_day_of_month and t.date <= ^last_day_of_month)
  end

  def monthly_expenses(date \\ Date.utc_today()) do
    query = from(t in transactions_this_month_query(date), where: t.type == "debit", select: sum(t.amount))
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

  def import_transactions(%Plug.Upload{path: path} = _file) do
    data = path
      |> File.stream!()
      |> CSV.decode()
      |> Stream.drop(1)
      |> Enum.map(fn (row) -> map_to_transaction(row) end)

    Repo.insert_all(Transaction, data)
  end


  defp map_to_transaction({:ok, [date, description, full_description, amount, type | _rest] }) do
    default_transaction_data = %{
    }
    %{
      date: Timex.to_date(Timex.parse!(date, "{M}/{D}/{YYYY}")),
      description: description,
      full_description: full_description,
      amount: Money.parse!(amount).amount,
      type: type,
      account_id: 2, # TODO: fixme
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    }
  end
end
