defmodule Bank.Core.Actions.DepositTest do
  use ExUnit.Case, async: false

  import Mox

  setup :verify_on_exit!

  alias Bank.Core.Actions.Boundaries.DepositInput
  alias Bank.Core.Actions.Deposit
  alias Bank.Core.Model.Account.MockService
  alias Bank.Core.Model.Amount

  alias Bank.Tests.Support

  @sample_account_id Support.new_id()

  describe "Deposit.execute" do
    test "should call account Service.deposit" do
      account_id = @sample_account_id
      {:ok, amount} = Amount.new(1000)
      time = Support.parse_date("10-01-2012")

      MockService
      |> expect(:deposit, fn account_id: ^account_id, amount: ^amount, time: ^time -> :ok end)

      input = %DepositInput{
        account_id: account_id,
        amount: amount,
        time: time
      }

      :ok = Deposit.execute(input: input)
    end
  end
end
