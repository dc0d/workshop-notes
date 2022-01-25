defmodule Bank.Core.Model.Statement.LineTest do
  use ExUnit.Case

  alias Bank.Core.Model.Amount
  alias Bank.Core.Model.Statement.Line

  alias Bank.Tests.Support

  ExUnit.Case.register_describe_attribute(__MODULE__, :test_fixtures, accumulate: true)

  describe "Print Statement Line" do
    @test_fixtures %{
      given: %Line{
        credit: Amount.new(1000) |> Support.get_result(),
        debit: Amount.new(0) |> Support.get_result(),
        balance: Amount.new(1000) |> Support.get_result(),
        time: Support.parse_date("10-01-2012")
      },
      then: "10/01/2012 || 1000.00 || || 1000.00"
    }
    @test_fixtures %{
      given: %Line{
        credit: Amount.new(2000) |> Support.get_result(),
        debit: Amount.new(0) |> Support.get_result(),
        balance: Amount.new(3000) |> Support.get_result(),
        time: Support.parse_date("13-01-2012")
      },
      then: "13/01/2012 || 2000.00 || || 3000.00"
    }
    @test_fixtures %{
      given: %Line{
        credit: Amount.new(0) |> Support.get_result(),
        debit: Amount.new(500) |> Support.get_result(),
        balance: Amount.new(2500) |> Support.get_result(),
        time: Support.parse_date("14-01-2012")
      },
      then: "14/01/2012 || || 500.00 || 2500.00"
    }

    test "when statement line to string", context do
      for %{
            given: statement,
            then: expected_result
          } <-
            context.registered.test_fixtures do
        assert "#{statement}" == expected_result
      end
    end
  end

  describe "Line.new" do
    @test_fixtures %{
      given: %Line{
        credit: Amount.new(1000) |> Support.get_result(),
        debit: Amount.new(0) |> Support.get_result(),
        balance: Amount.new(1000) |> Support.get_result(),
        time: Support.parse_date("10-01-2012")
      },
      then:
        {:ok,
         %Line{
           credit: Amount.new(1000) |> Support.get_result(),
           debit: Amount.new(0) |> Support.get_result(),
           balance: Amount.new(1000) |> Support.get_result(),
           time: Support.parse_date("10-01-2012")
         }}
    }

    @nil_time %Line{
      credit: Amount.new(1000) |> Support.get_result(),
      debit: Amount.new(0) |> Support.get_result(),
      balance: Amount.new(1000) |> Support.get_result(),
      time: nil
    }
    @test_fixtures %{
      given: @nil_time,
      then: {:error, {:invalid_input, @nil_time}}
    }

    @nil_credit %Line{
      credit: nil,
      debit: Amount.new(0) |> Support.get_result(),
      balance: Amount.new(1000) |> Support.get_result(),
      time: Support.parse_date("10-01-2012")
    }
    @test_fixtures %{
      given: @nil_credit,
      then: {:error, {:invalid_input, @nil_credit}}
    }

    @nil_debit %Line{
      credit: Amount.new(1000) |> Support.get_result(),
      debit: nil,
      balance: Amount.new(1000) |> Support.get_result(),
      time: Support.parse_date("10-01-2012")
    }
    @test_fixtures %{
      given: @nil_debit,
      then: {:error, {:invalid_input, @nil_debit}}
    }

    @nil_balance %Line{
      credit: Amount.new(1000) |> Support.get_result(),
      debit: Amount.new(0) |> Support.get_result(),
      balance: nil,
      time: Support.parse_date("10-01-2012")
    }
    @test_fixtures %{
      given: @nil_balance,
      then: {:error, {:invalid_input, @nil_balance}}
    }

    @test_fixtures %{
      given: :some_invalid_input,
      then: {:error, {:invalid_input, :some_invalid_input}}
    }

    test "when calling new", context do
      for %{
            given: input_args,
            then: expected_result
          } <-
            context.registered.test_fixtures do
        assert Line.new(input_args) == expected_result
      end
    end
  end
end
