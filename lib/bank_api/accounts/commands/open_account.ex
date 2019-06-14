defmodule BankAPI.Accounts.Commands.OpenAccount do
  @enforce_keys [:account_uuid]
  @uuid_regex ~r/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/

  defstruct [:account_uuid, :initial_balance]

  def valid?(command) do
    Skooma.valid?(Map.from_struct(command), schema())
  end

  defp schema do
    %{
      account_uuid: [:string, Skooma.Validators.regex(@uuid_regex)],
      initial_balance: [:int, &positive_integer(&1)]
    }
  end

  defp positive_integer(i) when is_integer(i) and i > 0, do: :ok

  defp positive_integer(i) when is_integer(i) do
    {:error, "Argument must be bigger than zero"}
  end

  defp positive_integer(_) do
    {:error, "Argument must be an integer"}
  end
end
