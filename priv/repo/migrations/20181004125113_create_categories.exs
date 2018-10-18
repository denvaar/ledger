defmodule Ledger.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table("categories") do
      add :name, :string, null: false
      add :frequency, :string, limit: 20, null: false
      add :allotment, :integer, default: 0, null: false

      timestamps()
    end
  end
end
