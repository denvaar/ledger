defmodule Ledger.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table("transactions") do
      add :date, :date
      add :amount, :integer, null: false
      add :description, :string, null: false
      add :full_description, :string
      add :type, :string, limit: 10, null: false
      add :notes, :text

      add :account_id, references(:accounts, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)
      add :parent_id, references(:transactions, on_delete: :delete_all)

      timestamps()
    end

    create index(:transactions, [:account_id, :category_id])
  end
end
