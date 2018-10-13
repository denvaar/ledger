defmodule Mix.Tasks.Seed do
  use Mix.Task

  @shortdoc "Run seed files in priv/repo/seeds/ directory"
  def run(_) do
    Application.app_dir(:ledger, "priv")
    |> Kernel.<>("/repo/seeds/*.exs")
    |> Path.wildcard()
    |> Enum.map(fn(seed_file) -> Mix.shell.cmd("mix run #{seed_file}") end)
  end
end
