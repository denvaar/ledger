defmodule Ledger.Budgets.Account do
  use Ecto.Schema
  import Ecto.Changeset


  schema "accounts" do
    field :name, :string
    field :type, :string
    field :balance, Money.Ecto.Type, default: 0

    has_many :transactions, Ledger.Budgets.Transaction

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :type, :balance])
    |> validate_required([:name, :type, :balance])
  end
end
