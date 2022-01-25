defmodule Bank.Core.Actions.Deposit do
  @moduledoc false

  @behaviour Bank.Core.Actions.Boundaries.Action

  alias Bank.Core.Actions.Boundaries.DepositInput

  def execute(input: %DepositInput{} = input) do
    account_service().deposit(
      account_id: input.account_id,
      amount: input.amount,
      time: input.time
    )
  end

  defp account_service do
    Application.get_env(:bank_kata_ex, :services) |> Map.get(:account)
  end
end
