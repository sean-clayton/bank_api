defmodule BankAPI.Accounts.Projectors.AccountClosed do
  use Commanded.Projections.Ecto,
    name: "Accounts.Projectors.AccountClosed"

  alias BankAPI.Accounts
  alias BankAPI.Accounts.Events.AccountClosed
  alias BankAPI.Accounts.Projections.Account
  alias Ecto.{Changeset, Multi}

  project(%AccountClosed{} = evt, _metadata, fn multi ->
    case Accounts.get_account(evt.account_uuid) do
      {:ok, %Account{} = account} ->
        Multi.update(
          multi,
          :account,
          Changeset.change(account, status: Account.status().closed)
        )

      _ ->
        multi
    end
  end)
end
