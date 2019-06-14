defmodule BankAPIWeb.AccountView do
  use BankAPIWeb, :view

  def render("show.json", %{account: account}) do
    %{data: render_one(account, __MODULE__, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{uuid: account.uuid, current_balance: account.current_balance}
  end
end
