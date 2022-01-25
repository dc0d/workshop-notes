defmodule Bank.Delivery.WebAPI.Boundaries.TransactionCommandPayloadTest do
  use ExUnit.Case, async: false

  ExUnit.Case.register_describe_attribute(__MODULE__, :test_fixtures, accumulate: true)

  alias Bank.Delivery.WebAPI.Boundaries.TransactionCommandPayload

  alias Bank.Tests.Support

  @deposit_command_term "DEPOSIT_AMOUNT"
  @withdraw_command_term "WITHDRAW_AMOUNT"
  @sample_account_id Support.new_id()
  @sample_time Support.parse_date("10-01-2012")
  @sample_time_string NaiveDateTime.to_iso8601(@sample_time)

  describe "TransactionCommandPayload.from_conn_params" do
    @test_fixtures %{
      given: %{
        command: @deposit_command_term,
        account_id: @sample_account_id,
        amount: 1000,
        time: @sample_time_string
      },
      then: {
        :ok,
        %TransactionCommandPayload{
          command: @deposit_command_term,
          account_id: @sample_account_id,
          amount: 1000,
          time: @sample_time
        }
      }
    }

    @test_fixtures %{
      given: %{
        command: @withdraw_command_term,
        account_id: @sample_account_id,
        amount: 1000,
        time: @sample_time_string
      },
      then: {
        :ok,
        %TransactionCommandPayload{
          command: @withdraw_command_term,
          account_id: @sample_account_id,
          amount: 1000,
          time: @sample_time
        }
      }
    }

    @test_fixtures %{
      given: %{
        command: @withdraw_command_term,
        account_id: @sample_account_id,
        amount: 1000,
        time: nil
      },
      then: {
        :error,
        {
          :invalid_payload,
          %{
            command: @withdraw_command_term,
            account_id: @sample_account_id,
            amount: 1000,
            time: nil
          }
        }
      }
    }

    @test_fixtures %{
      given: %{
        command: "UNKNOWN_COMMAND",
        account_id: @sample_account_id,
        amount: 1000,
        time: @sample_time_string
      },
      then: {
        :error,
        {
          :invalid_payload,
          %{
            command: "UNKNOWN_COMMAND",
            account_id: @sample_account_id,
            amount: 1000,
            time: @sample_time_string
          }
        }
      }
    }

    @test_fixtures %{
      given: %{
        command: @deposit_command_term,
        account_id: nil,
        amount: 1000,
        time: @sample_time_string
      },
      then: {
        :error,
        {
          :invalid_payload,
          %{
            command: @deposit_command_term,
            account_id: nil,
            amount: 1000,
            time: @sample_time_string
          }
        }
      }
    }

    @test_fixtures %{
      given: %{
        command: @deposit_command_term,
        account_id: @sample_account_id,
        amount: nil,
        time: @sample_time_string
      },
      then: {
        :error,
        {
          :invalid_payload,
          %{
            command: @deposit_command_term,
            account_id: @sample_account_id,
            amount: nil,
            time: @sample_time_string
          }
        }
      }
    }

    @test_fixtures %{
      given: %{
        command: @deposit_command_term,
        account_id: @sample_account_id,
        amount: "NOT A NUMBER",
        time: @sample_time_string
      },
      then: {
        :error,
        {
          :invalid_payload,
          %{
            command: @deposit_command_term,
            account_id: @sample_account_id,
            amount: "NOT A NUMBER",
            time: @sample_time_string
          }
        }
      }
    }

    test "when calling from_conn_params", context do
      for %{given: conn_params, then: expected_result} <-
            context.registered.test_fixtures do
        assert TransactionCommandPayload.from_conn_params(conn_params) ==
                 expected_result
      end
    end
  end
end
