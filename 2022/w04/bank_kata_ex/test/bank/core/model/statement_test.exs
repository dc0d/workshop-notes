defmodule Bank.Core.Model.StatementTest do
  use ExUnit.Case

  alias Bank.Core.Model.Amount
  alias Bank.Core.Model.Statement.Line
  alias Bank.Core.Model.Statement

  alias Bank.Tests.Support

  ExUnit.Case.register_describe_attribute(__MODULE__, :test_fixtures, accumulate: true)

  @sample_statement_lines [
    %Line{
      credit: Amount.new(0) |> Support.get_result(),
      debit: Amount.new(500) |> Support.get_result(),
      balance: Amount.new(2500) |> Support.get_result(),
      time: Support.parse_date("14-01-2012")
    },
    %Line{
      credit: Amount.new(2000) |> Support.get_result(),
      debit: Amount.new(0) |> Support.get_result(),
      balance: Amount.new(3000) |> Support.get_result(),
      time: Support.parse_date("13-01-2012")
    },
    %Line{
      credit: Amount.new(1000) |> Support.get_result(),
      debit: Amount.new(0) |> Support.get_result(),
      balance: Amount.new(1000) |> Support.get_result(),
      time: Support.parse_date("10-01-2012")
    }
  ]

  @sample_statement %Statement{lines: @sample_statement_lines}

  describe "Print Bank Statement" do
    setup do
      statement_lines = @sample_statement_lines

      {:ok, statement} = Statement.new(statement_lines)

      [
        statement: statement,
        expected_bank_statement: """
        date || credit || debit || balance
        14/01/2012 || || 500.00 || 2500.00
        13/01/2012 || 2000.00 || || 3000.00
        10/01/2012 || 1000.00 || || 1000.00
        """
      ]
    end

    test "statement to text", context do
      assert "#{context.statement}" == context.expected_bank_statement
    end
  end

  describe "Statement.new" do
    @test_fixtures %{given: @sample_statement_lines, then: {:ok, @sample_statement}}
    @test_fixtures %{given: :an_unexpected_input, then: {:error, :invalid_statement_lines}}

    test "when calling new", context do
      for %{given: statement_lines, then: expected_statement} <-
            context.registered.test_fixtures do
        assert Statement.new(statement_lines) == expected_statement
      end
    end
  end
end
