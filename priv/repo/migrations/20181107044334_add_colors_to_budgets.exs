defmodule Ledger.Repo.Migrations.AddColorsToBudgets do
  use Ecto.Migration
  import Ecto.Query

  def change do
    alter table(:categories) do
      add :color, :string, limit: 10
    end

    flush() # the toilet lol

    from(c in "categories",
         update: [set: [color: "#ffffff"]])
    |> Ledger.Repo.update_all([])
  end
end
