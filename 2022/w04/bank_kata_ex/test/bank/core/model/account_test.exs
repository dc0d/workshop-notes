defmodule Bank.Core.Model.AccountTest do
  use ExUnit.Case

  alias Bank.Core.Model.Account
  alias Bank.Core.Model.Transaction
  alias Bank.Core.Model.Amount

  alias Bank.Tests.Support

  ExUnit.Case.register_describe_attribute(__MODULE__, :test_fixtures, accumulate: true)

  @sample_account_id Support.new_id()
  @sample_time Support.parse_date("10-01-2012")
  @sample_deposit_transaction Transaction.new(%Amount{value: 100}, @sample_time)
                              |> Support.get_result()
  @sample_withdraw_transaction Transaction.new(%Amount{value: -100}, @sample_time)
                               |> Support.get_result()

  describe "Account.deposit" do
    @test_fixtures %{
      given: %{
        account: %Account{account_id: @sample_account_id},
        amount: %Amount{value: 100},
        time: @sample_time
      },
      then: {
        :ok,
        %Account{
          account_id: @sample_account_id,
          transactions: [@sample_deposit_transaction]
        }
      }
    }

    @test_fixtures %{
      given: %{
        account: %Account{account_id: @sample_account_id},
        amount: %Amount{value: -100},
        time: @sample_time
      },
      then: {
        :ok,
        %Account{
          account_id: @sample_account_id,
          transactions: [@sample_deposit_transaction]
        }
      }
    }

    test "when deposit", context do
      for %{given: %{account: account, amount: amount, time: time}, then: expected_result} <-
            context.registered.test_fixtures do
        assert Account.deposit(account: account, amount: amount, time: time) ==
                 expected_result
      end
    end
  end

  describe "Account.withdraw" do
    @test_fixtures %{
      given: %{
        account: %Account{account_id: @sample_account_id},
        amount: %Amount{value: -100},
        time: @sample_time
      },
      then: {
        :ok,
        %Account{
          account_id: @sample_account_id,
          transactions: [@sample_withdraw_transaction]
        }
      }
    }

    @test_fixtures %{
      given: %{
        account: %Account{account_id: @sample_account_id},
        amount: %Amount{value: 100},
        time: @sample_time
      },
      then: {
        :ok,
        %Account{
          account_id: @sample_account_id,
          transactions: [@sample_withdraw_transaction]
        }
      }
    }

    test "when withdraw", context do
      for %{given: %{account: account, amount: amount, time: time}, then: expected_result} <-
            context.registered.test_fixtures do
        assert Account.withdraw(account: account, amount: amount, time: time) ==
                 expected_result
      end
    end
  end

  describe "Account.new" do
    @test_fixtures %{
      given: @sample_account_id,
      then: {:ok, %Account{account_id: @sample_account_id}}
    }

    @test_fixtures %{
      given: nil,
      then: {:error, :invalid_account_id}
    }

    @test_fixtures %{
      given: :some_invalid_input,
      then: {:error, :invalid_account_id}
    }

    test "when new", context do
      for %{given: account_id, then: expected_result} <-
            context.registered.test_fixtures do
        assert Account.new(account_id) == expected_result
      end
    end
  end

  describe "Account.print_statement" do
    setup do
      {:ok, account} = Account.new(@sample_account_id)

      {:ok, account} =
        Account.deposit(
          account: account,
          amount: %Amount{value: 1000},
          time: Support.parse_date("10-01-2012")
        )

      {:ok, account} =
        Account.deposit(
          account: account,
          amount: %Amount{value: 2000},
          time: Support.parse_date("13-01-2012")
        )

      {:ok, account} =
        Account.withdraw(
          account: account,
          amount: %Amount{value: 500},
          time: Support.parse_date("14-01-2012")
        )

      [
        account: account,
        expected_bank_statement: """
        date || credit || debit || balance
        14/01/2012 || || 500.00 || 2500.00
        13/01/2012 || 2000.00 || || 3000.00
        10/01/2012 || 1000.00 || || 1000.00
        """
      ]
    end

    test "when account", context do
      assert Account.print_statement(account: context.account) ==
               {:ok, context.expected_bank_statement}
    end
  end
end
