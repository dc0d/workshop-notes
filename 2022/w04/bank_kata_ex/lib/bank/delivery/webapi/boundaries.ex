defmodule Bank.Delivery.WebAPI.Boundaries.TransactionCommandPayload do
  @moduledoc false

  alias __MODULE__

  @deposit_command_term "DEPOSIT_AMOUNT"
  @withdraw_command_term "WITHDRAW_AMOUNT"

  @derive {Jason.Encoder, only: [:command, :account_id, :amount, :time]}
  @enforce_keys [:command, :account_id, :amount, :time]
  defstruct command: "",
            account_id: "",
            amount: 0,
            time: nil

  @type t :: %TransactionCommandPayload{
          command: String.t(),
          account_id: String.t(),
          amount: integer,
          time: NaiveDateTime.t()
        }

  @spec from_conn_params(%{
          :account_id => any,
          :amount => any,
          :command => any,
          :time => any,
          optional(any) => any
        }) ::
          {:error,
           {:invalid_payload,
            %{
              :account_id => any,
              :amount => any,
              :command => any,
              :time => any,
              optional(any) => any
            }}}
          | {:ok, TransactionCommandPayload.t()}
  def from_conn_params(
        %{
          command: command,
          account_id: account_id,
          amount: amount,
          time: time
        } = params
      )
      when is_nil(account_id) or is_nil(amount) or is_nil(time) or not is_number(amount) or
             command not in [@deposit_command_term, @withdraw_command_term] do
    {:error, {:invalid_payload, params}}
  end

  def from_conn_params(
        %{
          command: command,
          account_id: account_id,
          amount: amount,
          time: time
        } = params
      ) do
    case NaiveDateTime.from_iso8601(time) do
      {:ok, time} ->
        {:ok,
         %TransactionCommandPayload{
           command: command,
           account_id: account_id,
           amount: amount,
           time: time
         }}

      _ ->
        {:error, {:invalid_payload, params}}
    end
  end
end
