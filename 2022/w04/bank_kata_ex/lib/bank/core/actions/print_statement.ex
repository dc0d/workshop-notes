defmodule Bank.Core.Actions.PrintStatement do
  @moduledoc false

  @behaviour Bank.Core.Actions.Boundaries.Action

  alias Bank.Core.Actions.Boundaries.PrintStatementInput

  def execute(input: %PrintStatementInput{} = input) do
    account_service().print_statement(account_id: input.account_id)
  end

  defp account_service do
    Application.get_env(:bank_kata_ex, :services) |> Map.get(:account)
  end
end
