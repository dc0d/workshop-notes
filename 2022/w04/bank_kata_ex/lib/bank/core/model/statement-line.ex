defmodule Bank.Core.Model.Statement.Line do
  @moduledoc false

  alias __MODULE__
  alias Bank.Core.Model.Amount

  @enforce_keys [:credit, :debit, :balance, :time]
  defstruct credit: %Amount{value: 0},
            debit: %Amount{value: 0},
            balance: %Amount{value: 0},
            time: nil

  @type t :: %Line{
          credit: Amount.t(),
          debit: Amount.t(),
          balance: Amount.t(),
          time: NaiveDateTime.t()
        }

  @spec new(any) :: {:error, {:invalid_input, any}} | {:ok, Line.t()}
  def new(
        %Line{
          credit: %Amount{} = credit,
          debit: %Amount{} = debit,
          balance: %Amount{} = balance,
          time: %NaiveDateTime{} = time
        } = input
      )
      when not is_nil(credit) and not is_nil(debit) and not is_nil(balance) and not is_nil(time),
      do: {:ok, input}

  def new(input), do: {:error, {:invalid_input, input}}

  defimpl String.Chars do
    @spec to_string(Line.t()) :: String.t()
    def to_string(%Line{} = statement),
      do:
        "#{format_date(statement.time)} || #{statement.credit} || #{statement.debit} || #{statement.balance}"
        |> String.replace("  ", " ")

    defp format_date(%NaiveDateTime{} = time),
      do: "#{pad_number(time.day)}/#{pad_number(time.month)}/#{time.year}"

    @spec pad_number(integer, non_neg_integer) :: binary
    def pad_number(n, pad \\ 2),
      do:
        n
        |> Integer.to_string()
        |> String.pad_leading(pad, "0")
  end
end
