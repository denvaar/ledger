defmodule Ledger.Budgets.Categories do
  @moduledoc """
  Category specific functionality for the budgets context.
  """

  import Ecto.Query, only: [from: 2]

  alias Ledger.Repo
  alias Ledger.Budgets.Category

  @colors [
    "Red":    "#d6655d",
    "Blue":   "#789fbd",
    "Green":  "#54b17c",
    "Orange": "#e6b163",
    "Peach":  "#f7b7a2",
    "Purple": "#8b76b1",
    "Teal":   "#64efe2",
    "Red 2":  "#ff6e64",
    "Army":   "#638264",
    "Blue 2": "#418fff",
    "Ugly":   "#963f5c",
    "Sand":   "#f3dbaa",
  ]

  def colors, do: @colors

  def available_colors(current_color) do
    used = used_colors()

    @colors
    |> Enum.reject(fn {_name, value} -> Enum.member?(used, value) && value != current_color end)
  end

  defp used_colors do
    from(c in "categories",
         select: c.color)
     |> Repo.all()
  end

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
