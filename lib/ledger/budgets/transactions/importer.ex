defmodule Ledger.Budgets.Transactions.Importer do

  alias Ledger.Repo
  alias Ledger.Budgets.Transaction


  def import_transactions(%Plug.Upload{path: path} = _file) do
    data = path
      |> File.stream!()
      |> CSV.decode()
      |> Stream.drop(1)
      |> Enum.map(fn (row) -> map_to_transaction(row) end)

    Repo.insert_all(Transaction, data)
  end


  defp map_to_transaction({:ok, [date, description, full_description, amount, type | _rest] }) do
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
