defmodule BankAPI.Accounts.Events.WithdrawnFromAccount do
  @derive [Jason.Encoder]

  defstruct [:account_uuid, :new_current_balance]
end
