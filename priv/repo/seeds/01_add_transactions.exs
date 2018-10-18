import Ecto.Query
alias Ledger.Budgets.{Account, Transaction}

random_date = fn(range) ->
  Date.utc_today()
  |> Date.add(Enum.random(range))
end

random_decimal = fn() ->
  :rand.uniform(9000)
end

text_data = """
The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz prog. Junk MTV quiz graced by fox whelps. Bawds jog, flick quartz, vex nymphs. Waltz, bad nymph, for quick jigs vex! Fox nymphs grab quick-jived waltz. Brick quiz whangs jumpy veldt fox. Bright vixens jump; dozy fowl quack. Quick wafting zephyrs vex bold Jim. Quick zephyrs blow, vexing daft Jim. Sex-charged fop blew my junk TV quiz. How quickly daft jumping zebras vex. Two driven jocks help fax my big quiz. Quick, Baz, get my woven flax jodhpurs! "Now fax quiz Jack!" my brave ghost pled. Five quacking zephyrs jolt my wax bed. Flummoxed by job, kvetching W. zaps Iraq. Cozy sphinx waves quart jug of bad milk. A very bad quack might jinx zippy fowls. Few quips galvanized the mock jury box. Quick brown dogs jump over the lazy fox. The jay, pig, fox, zebra, and my wolves quack! Blowzy red vixens fight for a quick jump. Joaquin Phoenix was gazed by MTV for luck. A wizard’s job is to vex chumps quickly in fog. Watch "Jeopardy!", Alex Trebek's fun TV quiz game. Woven silk pyjamas exchanged for blue quartz. Brawny gods just
"""

accounts = Ledger.Repo.all(from(a in Account, select: a.id))

get_account = fn(ids) ->
  ids
  |> Enum.at(:rand.uniform(length(ids)))
end

gen_rand_text = fn(n_words) ->
  text_data
  |> String.split()
  |> Enum.shuffle()
  |> Enum.slice(0, n_words)
  |> Enum.join(" ")
end

transactions = [
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "debit",
    account_id: get_account.(accounts)
  },
  %{
    date: random_date.(-50..50),
    amount: random_decimal.(),
    description: gen_rand_text.(5),
    full_description: gen_rand_text.(10),
    type: "credit",
    account_id: get_account.(accounts)
  },
]

default_transaction_data = %{
  inserted_at: DateTime.utc_now(),
  updated_at: DateTime.utc_now()
}

transactions = Enum.map(transactions, fn(transaction_data) ->
  Map.merge(transaction_data, default_transaction_data) end)

Ledger.Repo.insert_all(Transaction, transactions)
