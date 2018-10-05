defmodule Ledger.Budgets.Transaction do
  use Ecto.Schema
  import Ecto.Changeset


  schema "transactions" do
    field :date, :date
    field :amount, :decimal, default: 0
    field :description, :string
    field :full_description, :string
    field :type, :string

    belongs_to :account, Ledger.Budgets.Account
    belongs_to :transaction, Ledger.Budgets.Transaction, foreign_key: :parent_id
    has_many :sub_transactions, Ledger.Budgets.Transaction, foreign_key: :parent_id

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:date, :amount, :description, :type, :account_id])
    |> validate_required([:date, :amount, :description, :type])
  end
end
