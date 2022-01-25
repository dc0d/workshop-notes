defmodule Bank.Core.Actions.Withdraw do
  @moduledoc false

  @behaviour Bank.Core.Actions.Boundaries.Action

  alias Bank.Core.Actions.Boundaries.WithdrawInput

  def execute(input: %WithdrawInput{} = input) do
    account_service().withdraw(
      account_id: input.account_id,
      amount: input.amount,
      time: input.time
    )
  end

  defp account_service do
    Application.get_env(:bank_kata_ex, :services) |> Map.get(:account)
  end
end
