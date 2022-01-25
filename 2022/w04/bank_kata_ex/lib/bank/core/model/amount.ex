defmodule Bank.Core.Model.Amount do
  @moduledoc false

  alias __MODULE__

  @enforce_keys [:value]
  defstruct value: 0

  @type t :: %Amount{value: float()}

  @spec new(any) :: {:ok, Amount.t()} | {:error, :invalid_amount}
  def new(amount) when is_float(amount) or is_number(amount), do: {:ok, %Amount{value: amount}}
  def new(_), do: {:error, :invalid_amount}

  defimpl String.Chars do
    @spec to_string(Amount.t()) :: String.t()
    def to_string(%Amount{value: amount}) when amount == 0, do: ""
    def to_string(%Amount{value: amount}), do: :erlang.float_to_binary(1.0 * amount, decimals: 2)
  end
end
