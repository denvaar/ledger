defmodule Ledger.Budgets.FilterParams do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :from_date, :date
    field :to_date, :date
  end

  @doc false
  def changeset(filter_params, attrs) do
    filter_params
    |> cast(attrs, [:from_date, :to_date])
    |> validate_required([:from_date, :to_date])
  end
end
