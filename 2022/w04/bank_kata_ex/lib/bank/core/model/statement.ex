defmodule Bank.Core.Model.Statement do
  @moduledoc false

  alias __MODULE__
  alias Bank.Core.Model.Statement.Line

  defstruct lines: []

  @type t :: %Statement{
          lines: [Line.t()]
        }

  @spec new([Line.t()]) :: {:error, :invalid_statement_lines} | {:ok, Statement.t()}
  def new(lines) when is_list(lines), do: {:ok, %Statement{lines: lines}}
  def new(_lines), do: {:error, :invalid_statement_lines}

  defimpl String.Chars do
    @spec to_string(Statement.t()) :: String.t()
    def to_string(%Statement{} = statement) do
      header = "date || credit || debit || balance\n"

      lines =
        statement.lines
        |> Enum.reduce("", fn s, acc -> acc <> "#{s}\n" end)

      "#{header}#{lines}"
    end
  end
end
