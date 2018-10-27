defmodule Ledger.Budgets.Categories do
  @moduledoc """
  Category specific functionality for the budgets context.
  """

  import Ecto.Query, only: [from: 2]

  alias Ledger.Repo
  alias Ledger.Budgets.Category

  def list_categories do
    Repo.all(Category)
  end

  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def get_category!(id) do
    Repo.get!(Category, id)
  end

  def category_options do
    Repo.all(from(category in Category, select: {category.name, category.id}))
  end
end
