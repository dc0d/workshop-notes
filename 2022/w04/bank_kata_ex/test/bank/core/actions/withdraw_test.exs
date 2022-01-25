defmodule Bank.Core.Actions.WithdrawTest do
  use ExUnit.Case, async: false

  import Mox

  setup :verify_on_exit!

  alias Bank.Core.Actions.Boundaries.WithdrawInput
  alias Bank.Core.Actions.Withdraw
  alias Bank.Core.Model.Account.MockService
  alias Bank.Core.Model.Amount

  alias Bank.Tests.Support

  @sample_account_id Support.new_id()

  describe "Withdraw.execute" do
    test "should call account Service.withdraw" do
      account_id = @sample_account_id
      {:ok, amount} = Amount.new(1000)
      time = Support.parse_date("10-01-2012")

      MockService
      |> expect(:withdraw, fn account_id: ^account_id, amount: ^amount, time: ^time -> :ok end)

      input = %WithdrawInput{
        account_id: account_id,
        amount: amount,
        time: time
      }

      :ok = Withdraw.execute(input: input)
    end
  end
end
