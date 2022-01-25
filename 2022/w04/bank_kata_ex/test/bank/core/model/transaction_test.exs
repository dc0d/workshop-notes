defmodule Bank.Core.Model.TransactionTest do
  use ExUnit.Case

  alias Bank.Core.Model.Amount
  alias Bank.Core.Model.Transaction

  alias Bank.Tests.Support

  @sample_deposit_amount Support.get_result(Amount.new(100))
  @sample_withdrawal_amount Support.get_result(Amount.new(-100))
  @sample_time NaiveDateTime.new(2022, 1, 1, 21, 19, 19, 19) |> Support.get_result()

  ExUnit.Case.register_describe_attribute(__MODULE__, :test_fixtures, accumulate: true)

  describe "Transaction.new" do
    @test_fixtures %{
      given: %{amount: @sample_deposit_amount, time: @sample_time},
      then: {:ok, %Transaction{amount: @sample_deposit_amount, time: @sample_time}}
    }

    @test_fixtures %{
      given: %{amount: @sample_deposit_amount, time: nil},
      then: {:error, :invalid_time}
    }

    @test_fixtures %{
      given: %{amount: nil, time: @sample_time},
      then: {:error, :invalid_amount}
    }

    test "when new", context do
      for %{given: %{amount: amount, time: time}, then: expected_result} <-
            context.registered.test_fixtures do
        assert Transaction.new(amount, time) == expected_result
      end
    end
  end

  describe "Transaction.get_type" do
    @test_fixtures %{
      given: Support.get_result(Transaction.new(@sample_deposit_amount, @sample_time)),
      then: {:ok, :deposit}
    }

    @test_fixtures %{
      given: Support.get_result(Transaction.new(@sample_withdrawal_amount, @sample_time)),
      then: {:ok, :withdrawal}
    }

    @test_fixtures %{
      given: %{some_other_object: true},
      then: {:error, :invalid_transaction}
    }

    test "when get_type", context do
      for %{given: tx, then: expected_result} <-
            context.registered.test_fixtures do
        assert Transaction.get_type(tx) == expected_result
      end
    end
  end
end
