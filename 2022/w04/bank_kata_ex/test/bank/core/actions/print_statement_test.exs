defmodule Bank.Core.Actions.PrintStatementTest do
  use ExUnit.Case, async: false

  import Mox

  setup :verify_on_exit!

  alias Bank.Core.Actions.Boundaries.PrintStatementInput
  alias Bank.Core.Actions.PrintStatement
  alias Bank.Core.Model.Account.MockService

  alias Bank.Tests.Support

  @sample_account_id Support.new_id()

  describe "PrintStatement.execute" do
    test "should call account Service.print_statement" do
      account_id = @sample_account_id

      MockService
      |> expect(:print_statement, fn account_id: ^account_id -> {:ok, ""} end)

      input = %PrintStatementInput{
        account_id: account_id
      }

      {:ok, ""} = PrintStatement.execute(input: input)
    end
  end
end
