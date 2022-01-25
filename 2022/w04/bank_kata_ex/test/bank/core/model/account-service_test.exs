defmodule Bank.Core.Model.Account.ServiceTest do
  use ExUnit.Case, async: false

  import Mox

  setup :verify_on_exit!

  alias Bank.Core.Model.Account.Service
  alias Bank.Core.Model.Account
  alias Bank.Core.Model.Amount
  alias Bank.Boundaries.MockAccountRepo

  alias Bank.Tests.Support

  ExUnit.Case.register_describe_attribute(__MODULE__, :test_fixtures, accumulate: true)

  @sample_account_id Support.new_id()

  describe "Service.deposit" do
    test "should call repo load" do
      account_id = @sample_account_id
      time = Support.parse_date("10-01-2012")
      {:ok, amount} = Amount.new(1000)

      MockAccountRepo
      |> stub(:save, fn _ -> :ok end)
      |> expect(:load, fn ^account_id -> Account.new(account_id) end)

      :ok = Service.deposit(account_id: account_id, amount: amount, time: time)
    end

    test "should call repo save" do
      account_id = @sample_account_id
      time = Support.parse_date("10-01-2012")
      {:ok, amount} = Amount.new(1000)

      account =
        with {:ok, account} <- Account.new(account_id),
             {:ok, account} <- Account.deposit(account: account, amount: amount, time: time) do
          account
        else
          error ->
            raise("unexpected #{inspect(error)}")
        end

      MockAccountRepo
      |> expect(:save, fn ^account -> :ok end)
      |> stub(:load, fn account_id -> Account.new(account_id) end)

      :ok = Service.deposit(account_id: account_id, amount: amount, time: time)
    end
  end

  describe "Service.withdraw" do
    test "should call repo load" do
      account_id = @sample_account_id
      time = Support.parse_date("10-01-2012")
      {:ok, amount} = Amount.new(1000)

      Bank.Boundaries.MockAccountRepo
      |> stub(:save, fn _ -> :ok end)
      |> expect(:load, fn ^account_id -> Account.new(account_id) end)

      :ok = Service.withdraw(account_id: account_id, amount: amount, time: time)
    end

    test "should call repo save" do
      account_id = @sample_account_id
      time = Support.parse_date("10-01-2012")
      {:ok, amount} = Amount.new(-1000)

      account =
        with {:ok, account} <- Account.new(account_id),
             {:ok, account} <- Account.withdraw(account: account, amount: amount, time: time) do
          account
        else
          error ->
            raise("unexpected #{inspect(error)}")
        end

      Bank.Boundaries.MockAccountRepo
      |> expect(:save, fn ^account -> :ok end)
      |> stub(:load, fn account_id -> Account.new(account_id) end)

      :ok = Service.withdraw(account_id: account_id, amount: amount, time: time)
    end
  end

  describe "Service.print_statement" do
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

    test "when print_statement", context do
      account_id = @sample_account_id

      Bank.Boundaries.MockAccountRepo
      |> expect(:load, fn ^account_id -> {:ok, context.account} end)

      assert Service.print_statement(account_id: @sample_account_id) ==
               {:ok, context.expected_bank_statement}
    end
  end
end
