defmodule Bank.Core.Model.Account do
  @moduledoc false

  alias __MODULE__
  alias Bank.Core.Model.Amount
  alias Bank.Core.Model.Transaction
  alias Bank.Core.Model.Statement
  alias Bank.Core.Model.Statement.Line

  @enforce_keys [:account_id]
  defstruct account_id: "", transactions: []

  @type t :: %Account{
          account_id: String.t(),
          transactions: [Transaction.t()]
        }

  @spec new(String.t()) :: {:error, :invalid_account_id} | {:ok, Account.t()}
  def new(account_id) when not is_nil(account_id) and is_binary(account_id),
    do: {:ok, %Account{account_id: account_id}}

  def new(_), do: {:error, :invalid_account_id}

  @spec deposit(account: Account.t(), amount: Amount.t(), time: NaiveDateTime.t()) ::
          {:ok, Account.t()}
  def deposit(
        account: %Account{} = account,
        amount: %Amount{} = amount,
        time: %NaiveDateTime{} = time
      ) do
    {:ok, amount} = get_deposit_amount(amount)
    {:ok, new_transaction} = Transaction.new(amount, time)
    {:ok, %Account{account | transactions: [new_transaction | account.transactions]}}
  end

  @spec withdraw(account: Account.t(), amount: Amount.t(), time: NaiveDateTime.t()) ::
          {:ok, Account.t()}
  def withdraw(
        account: %Account{} = account,
        amount: %Amount{} = amount,
        time: %NaiveDateTime{} = time
      ) do
    {:ok, amount} = get_withdraw_amount(amount)
    {:ok, new_transaction} = Transaction.new(amount, time)
    {:ok, %Account{account | transactions: [new_transaction | account.transactions]}}
  end

  def print_statement(account: %Account{} = account) do
    lines =
      account.transactions
      |> Enum.reverse()
      |> Enum.reduce([], fn %Transaction{amount: amount, time: time} = tx, acc ->
        prev_balance = prev_balance_of(acc)

        line = make_statement_line(tx, amount, prev_balance, time)

        [line | acc]
      end)

    {:ok, statement} = Statement.new(lines)

    {:ok, "#{statement}"}
  end

  defp make_statement_line(tx, amount, prev_balance, time) do
    {:ok, line} =
      case Transaction.get_type(tx) do
        {:ok, :withdrawal} ->
          {:ok, abs_amount} = Amount.new(abs(amount.value))
          {:ok, balance} = Amount.new(prev_balance.value - abs_amount.value)

          Line.new(%Line{
            credit: zero_amount(),
            debit: abs_amount,
            balance: balance,
            time: time
          })

        {:ok, :deposit} ->
          {:ok, balance} = Amount.new(prev_balance.value + amount.value)

          Line.new(%Line{
            credit: amount,
            debit: zero_amount(),
            balance: balance,
            time: time
          })
      end

    line
  end

  defp prev_balance_of(acc) do
    case acc do
      [] -> zero_amount()
      [l | _] -> l.balance
    end
  end

  defp zero_amount() do
    {:ok, zero_amount} = Amount.new(0)
    zero_amount
  end

  defp get_deposit_amount(%Amount{value: value} = amount) when value > 0, do: {:ok, amount}
  defp get_deposit_amount(%Amount{value: value}), do: Amount.new(-1 * value)

  defp get_withdraw_amount(%Amount{value: value} = amount) when value < 0, do: {:ok, amount}
  defp get_withdraw_amount(%Amount{value: value}), do: Amount.new(-1 * value)
end
