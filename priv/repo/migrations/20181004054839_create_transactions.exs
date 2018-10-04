defmodule Ledger.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table("transactions") do
      add :date, :date
      add :description, :string, null: false
      add :full_description, :string
      add :amount, :decimal, null: false
      add :type, :string, limit: 10, null: false
      add :notes, :text

      timestamps()
    end
  end
end
