defmodule Bank.Delivery.WebAPITest do
  use ExUnit.Case, async: false
  use Plug.Test
  import Mox

  setup :verify_on_exit!

  ExUnit.Case.register_describe_attribute(__MODULE__, :test_fixtures, accumulate: true)

  alias Bank.Tests.Support

  alias Bank.Core.Actions.Boundaries.MockDepositAction
  alias Bank.Core.Actions.Boundaries.DepositInput
  alias Bank.Core.Actions.Boundaries.MockWithdrawAction
  alias Bank.Core.Actions.Boundaries.WithdrawInput
  alias Bank.Core.Actions.Boundaries.MockPrintStatementAction
  alias Bank.Core.Actions.Boundaries.PrintStatementInput
  alias Bank.Core.Model.Amount
  alias Bank.Delivery.WebAPI.Boundaries.TransactionCommandPayload
  alias Bank.Delivery.WebAPI

  @opts WebAPI.init([])

  @sample_account_id Support.new_id()
  @sample_numeric_amount 1000
  @sample_amount %Amount{value: @sample_numeric_amount}
  @sample_time Support.parse_date("10-01-2012")

  @deposit_command_term "DEPOSIT_AMOUNT"
  @withdraw_command_term "WITHDRAW_AMOUNT"

  describe "POST /api/bank/transactions deposit" do
    setup do
      command_payload = %TransactionCommandPayload{
        command: @deposit_command_term,
        account_id: @sample_account_id,
        amount: @sample_numeric_amount,
        time: @sample_time
      }

      expected_deposit_input = %DepositInput{
        account_id: @sample_account_id,
        amount: @sample_amount,
        time: @sample_time
      }

      [
        command_payload: command_payload,
        expected_deposit_input: expected_deposit_input
      ]
    end

    test "should trigger deposit action", context do
      command_payload = context.command_payload
      expected_input = context.expected_deposit_input

      expect(MockDepositAction, :execute, fn input: ^expected_input ->
        :ok
      end)

      post("/api/bank/transactions", command_payload)
    end
  end

  describe "POST /api/bank/transactions withdraw" do
    setup do
      command_payload = %TransactionCommandPayload{
        command: @withdraw_command_term,
        account_id: @sample_account_id,
        amount: @sample_numeric_amount,
        time: @sample_time
      }

      expected_withdraw_input = %WithdrawInput{
        account_id: @sample_account_id,
        amount: @sample_amount,
        time: @sample_time
      }

      [
        command_payload: command_payload,
        expected_withdraw_input: expected_withdraw_input
      ]
    end

    test "should trigger withdraw action", context do
      command_payload = context.command_payload
      expected_input = context.expected_withdraw_input

      expect(MockWithdrawAction, :execute, fn input: ^expected_input ->
        :ok
      end)

      post("/api/bank/transactions", command_payload)
    end
  end

  describe "GET /api/bank/:account_id/statement" do
    test "should trigger print statement action" do
      expected_input = %PrintStatementInput{account_id: @sample_account_id}

      expect(MockPrintStatementAction, :execute, fn input: ^expected_input ->
        {:ok, "some statement"}
      end)

      get("/api/bank/#{@sample_account_id}/statement")
    end
  end

  defp post(endpoint, payload) do
    js = Jason.encode!(payload)
    make_request(:post, endpoint, js)
  end

  defp get(endpoint) do
    conn(:get, endpoint)
    |> put_req_header("content-type", "application/json")
    |> put_req_header("accept", "application/json")
    |> WebAPI.call(@opts)
  end

  defp make_request(method, endpoint, payload) do
    conn(method, endpoint, payload)
    |> put_req_header("content-type", "application/json")
    |> WebAPI.call(@opts)
  end
end
