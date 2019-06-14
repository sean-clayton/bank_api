defmodule BankAPI.Accounts.Commands.Validators do
  def positive_integer(i, minimum \\ 0)

  def positive_integer(i, minimum) when is_integer(i) and i > minimum,
    do: :ok

  def positive_integer(i, minimum) when is_integer(i) do
    {:error, "Argument must be bigger than #{minimum}"}
  end

  def positive_integer(_, _) do
    {:error, "Argument must be an integer"}
  end
end
