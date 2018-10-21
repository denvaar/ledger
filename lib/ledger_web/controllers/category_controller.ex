defmodule LedgerWeb.CategoryController do
  use LedgerWeb, :controller

  alias Ledger.Budgets
  alias Ledger.Budgets.Category

  def index(conn, _params) do
    categories = Budgets.list_categories()
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Budgets.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case Budgets.create_category(category_params) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Budget created successfully.")
        |> redirect(to: category_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    category = Budgets.get_category!(id)
    changeset = Budgets.change_category(category)

    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Budgets.get_category!(id)

    case Budgets.update_category(category, category_params) do
      {:ok, _account} ->
        conn
        |> put_flash(:info, "Budget updated successfully.")
        |> redirect(to: category_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end
end
