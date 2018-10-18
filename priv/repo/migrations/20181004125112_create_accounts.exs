defmodule Ledger.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table("accounts") do
      add :name, :string, null: false
      add :type, :string, limit: 20, null: false
      add :balance, :integer, default: 0, null: false

      timestamps()
    end
  end
end
