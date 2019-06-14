defmodule BankAPIWeb.AccountView do
  use BankAPIWeb, :view

  alias BankAPI.Accounts.Projections.Account

  def render("show.json", %{account: account}) do
    %{data: render_one(account, __MODULE__, "account.json")}
  end

  def render("account.json", %{account: account}) do
    cond do
      account.status == Account.status().closed ->
        %{uuid: account.uuid, current_balance: account.current_balance}

      true ->
        %{
          uuid: account.uuid,
          current_balance: account.current_balance,
          status: account.status
        }
    end
  end
end
