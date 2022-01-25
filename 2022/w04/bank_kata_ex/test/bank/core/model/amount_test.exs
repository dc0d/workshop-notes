defmodule Bank.Core.Model.AmountTest do
  use ExUnit.Case

  alias Bank.Core.Model.Amount

  ExUnit.Case.register_describe_attribute(__MODULE__, :test_fixtures, accumulate: true)

  describe "Amount.new" do
    @test_fixtures %{given: 10.0, then: {:ok, %Amount{value: 10.0}}}
    @test_fixtures %{given: 10, then: {:ok, %Amount{value: 10.0}}}
    @test_fixtures %{given: 1000, then: {:ok, %Amount{value: 1000}}}
    @test_fixtures %{given: -500, then: {:ok, %Amount{value: -500}}}
    @test_fixtures %{given: "100.1", then: {:error, :invalid_amount}}
    @test_fixtures %{given: nil, then: {:error, :invalid_amount}}
    @test_fixtures %{
      given: :some_atom,
      then: {:error, :invalid_amount}
    }
    @test_fixtures %{
      given: "some string",
      then: {:error, :invalid_amount}
    }

    test "when new", context do
      for %{given: amount, then: expected_result} <-
            context.registered.test_fixtures do
        assert Amount.new(amount) == expected_result
      end
    end
  end

  describe "Amount.to_string" do
    @test_fixtures %{given: %Amount{value: 10}, then: "10.00"}
    @test_fixtures %{given: %Amount{value: 500}, then: "500.00"}
    @test_fixtures %{given: %Amount{value: -500}, then: "-500.00"}
    @test_fixtures %{given: %Amount{value: 0}, then: ""}

    test "when to_string", context do
      for %{given: amount, then: expected_string} <-
            context.registered.test_fixtures do
        assert "#{amount}" == expected_string
      end
    end
  end
end
