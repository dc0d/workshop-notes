defmodule Bank.Core.Model.Transaction do
  @moduledoc false

  alias __MODULE__
  alias Bank.Core.Model.Amount

  @enforce_keys [:amount, :time]
  defstruct amount: %Amount{value: 0}, time: nil

  @type transaction_type :: :deposit | :withdrawal

  @type t :: %Transaction{
          amount: Amount.t(),
          time: NaiveDateTime.t()
        }

  @spec new(Amount.t(), NaiveDateTime.t()) ::
          {:error, :invalid_amount | :invalid_time} | {:ok, Transaction.t()}
  def new(nil, %NaiveDateTime{}), do: {:error, :invalid_amount}
  def new(%Amount{}, nil), do: {:error, :invalid_time}

  def new(%Amount{} = amount, %NaiveDateTime{} = time),
    do: {:ok, %Transaction{amount: amount, time: time}}

  @spec get_type(any) ::
          {:error, :invalid_transaction} | {:ok, transaction_type}
  def get_type(%Transaction{amount: %Amount{value: amount}}) when amount < 0,
    do: {:ok, :withdrawal}

  def get_type(%Transaction{amount: %Amount{value: amount}}) when amount >= 0,
    do: {:ok, :deposit}

  def get_type(_),
    do: {:error, :invalid_transaction}
end
