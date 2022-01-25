defmodule Bank.Core.Model.Account.Boundaries.Service do
  @moduledoc false

  alias Bank.Core.Model.Amount

  @type reason :: any()
  @type bank_statement :: String.t()

  @callback deposit(account_id: String.t(), amount: Amount.t(), time: NaiveDateTime.t()) ::
              :ok | {:error, reason()}
  @callback withdraw(account_id: String.t(), amount: Amount.t(), time: NaiveDateTime.t()) ::
              :ok | {:error, reason()}
  @callback print_statement(account_id: String.t()) :: {:ok, bank_statement} | {:error, reason()}
end
