defmodule Bank.Core.Actions.Boundaries.DepositInput do
  @moduledoc false

  alias __MODULE__
  alias Bank.Core.Model.Amount

  @enforce_keys [:account_id, :amount, :time]
  defstruct account_id: "",
            amount: %Amount{value: 0},
            time: nil

  @type t :: %DepositInput{
          account_id: String.t(),
          amount: Amount,
          time: NaiveDateTime.t()
        }
end

defmodule Bank.Core.Actions.Boundaries.WithdrawInput do
  @moduledoc false

  alias __MODULE__
  alias Bank.Core.Model.Amount

  @enforce_keys [:account_id, :amount, :time]
  defstruct account_id: "",
            amount: %Amount{value: 0},
            time: nil

  @type t :: %WithdrawInput{
          account_id: String.t(),
          amount: Amount,
          time: NaiveDateTime.t()
        }
end

defmodule Bank.Core.Actions.Boundaries.PrintStatementInput do
  @moduledoc false

  alias __MODULE__

  @enforce_keys [:account_id]
  defstruct account_id: ""

  @type t :: %PrintStatementInput{
          account_id: String.t()
        }
end

defmodule Bank.Core.Actions.Boundaries.Action do
  @moduledoc false

  alias Bank.Core.Actions.Boundaries.DepositInput
  alias Bank.Core.Actions.Boundaries.WithdrawInput
  alias Bank.Core.Actions.Boundaries.PrintStatementInput

  @type reason :: any()
  @type result :: any()
  @type action_input :: DepositInput.t() | WithdrawInput.t() | PrintStatementInput.t()

  @callback execute(input: action_input()) ::
              :ok | {:ok, result()} | :error | {:error, reason()}
end
