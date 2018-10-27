defmodule Ledger.Budgets.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string
    field :frequency, :string
    field :allotment, Money.Ecto.Type, default: 0

    has_many :transactions, Ledger.Budgets.Transaction

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :frequency, :allotment])
    |> validate_required([:name, :frequency, :allotment])
  end
end
