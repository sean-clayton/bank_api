defmodule BankAPI.Accounts.Aggregates.Account do
  defstruct uuid: nil,
            current_balance: nil,
            closed?: false

  alias __MODULE__

  alias BankAPI.Accounts.Commands.{
    OpenAccount,
    CloseAccount,
    DepositIntoAccount,
    WithdrawFromAccount
  }

  alias BankAPI.Accounts.Events.{
    AccountOpened,
    AccountClosed,
    DepositedIntoAccount,
    WithdrawnFromAccount
  }

  def execute(%Account{uuid: account_uuid, closed?: true}, %CloseAccount{
        account_uuid: account_uuid
      }) do
    {:error, :account_already_closed}
  end

  def execute(%Account{uuid: account_uuid, closed?: false}, %CloseAccount{
        account_uuid: account_uuid
      }) do
    %AccountClosed{
      account_uuid: account_uuid
    }
  end

  def execute(%Account{}, %CloseAccount{}) do
    {:error, :not_found}
  end

  def execute(
        %Account{
          uuid: account_uuid,
          closed?: false,
          current_balance: current_balance
        },
        %DepositIntoAccount{account_uuid: account_uuid, deposit_amount: amount}
      ) do
    %DepositedIntoAccount{
      account_uuid: account_uuid,
      new_current_balance: current_balance + amount
    }
  end

  def execute(%Account{uuid: account_uuid, closed?: true}, %DepositIntoAccount{
        account_uuid: account_uuid
      }) do
    {:error, :account_closed}
  end

  def execute(
        %Account{},
        %DepositIntoAccount{}
      ) do
    {:error, :not_found}
  end

  def execute(
        %Account{
          uuid: account_uuid,
          closed?: false,
          current_balance: current_balance
        },
        %WithdrawFromAccount{
          account_uuid: account_uuid,
          withdraw_amount: amount
        }
      ) do
    cond do
      current_balance - amount > 0 ->
        %WithdrawnFromAccount{
          account_uuid: account_uuid,
          new_current_balance: current_balance - amount
        }

      true ->
        {:error, :insufficient_funds}
    end
  end

  def execute(%Account{uuid: account_uuid, closed?: true}, %WithdrawFromAccount{
        account_uuid: account_uuid
      }) do
    {:error, :account_closed}
  end

  def execute(
        %Account{},
        %WithdrawFromAccount{}
      ) do
    {:error, :not_found}
  end

  def execute(
        %Account{uuid: nil},
        %OpenAccount{
          account_uuid: account_uuid,
          initial_balance: initial_balance
        }
      )
      when initial_balance > 0 do
    %AccountOpened{
      account_uuid: account_uuid,
      initial_balance: initial_balance
    }
  end

  def execute(
        %Account{uuid: nil},
        %OpenAccount{
          initial_balance: initial_balance
        }
      )
      when initial_balance <= 0 do
    {:error, :initial_balance_must_be_above_zero}
  end

  def execute(%Account{}, %OpenAccount{}) do
    {:error, :account_already_opened}
  end

  # state mutators

  def apply(%Account{uuid: account_uuid} = account, %AccountClosed{
        account_uuid: account_uuid
      }) do
    %Account{
      account
      | closed?: true
    }
  end

  def apply(
        %Account{uuid: account_uuid, current_balance: _current_balance} =
          account,
        %DepositedIntoAccount{
          account_uuid: account_uuid,
          new_current_balance: new_current_balance
        }
      ) do
    %Account{account | current_balance: new_current_balance}
  end

  def apply(
        %Account{
          uuid: account_uuid,
          current_balance: _current_balance
        } = account,
        %WithdrawnFromAccount{
          account_uuid: account_uuid,
          new_current_balance: new_current_balance
        }
      ) do
    %Account{
      account
      | current_balance: new_current_balance
    }
  end

  def apply(
        %Account{} = account,
        %AccountOpened{
          account_uuid: account_uuid,
          initial_balance: initial_balance
        }
      ) do
    %Account{
      account
      | uuid: account_uuid,
        current_balance: initial_balance
    }
  end
end
