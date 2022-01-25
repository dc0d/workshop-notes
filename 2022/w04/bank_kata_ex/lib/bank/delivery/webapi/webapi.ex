defmodule Bank.Delivery.WebAPI.Transactions do
  @moduledoc false

  use Plug.Router

  alias Plug.Conn.Status

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: {Jason, :decode!, [[keys: :atoms]]}
  )

  plug(:dispatch)

  alias Bank.Delivery.WebAPI.Boundaries.TransactionCommandPayload
  alias Bank.Core.Actions.Boundaries.DepositInput
  alias Bank.Core.Actions.Boundaries.WithdrawInput
  alias Bank.Core.Model.Amount

  post "/" do
    with {:ok, command} <- TransactionCommandPayload.from_conn_params(conn.params),
         {:ok, response} <- handle_command(command) do
      send_resp(conn, Status.code(:ok), response)
    else
      {:error, error} ->
        data = %{error: error, params: conn.params}
        send_resp(conn, Status.code(:bad_request), "FAILED COMMAND #{inspect(data)}")
    end
  end

  defp handle_command(%TransactionCommandPayload{
         command: "DEPOSIT_AMOUNT",
         account_id: account_id,
         amount: amount_value,
         time: time
       }) do
    with {:ok, amount} <- Amount.new(amount_value),
         :ok <-
           deposit_action().execute(
             input: %DepositInput{
               account_id: account_id,
               amount: amount,
               time: time
             }
           ) do
      {:ok, ""}
    else
      error ->
        {:error, error}
    end
  end

  defp handle_command(%TransactionCommandPayload{
         command: "WITHDRAW_AMOUNT",
         account_id: account_id,
         amount: amount_value,
         time: time
       }) do
    with {:ok, amount} <- Amount.new(amount_value),
         :ok <-
           withdraw_action().execute(
             input: %WithdrawInput{
               account_id: account_id,
               amount: amount,
               time: time
             }
           ) do
      {:ok, ""}
    else
      error ->
        {:error, error}
    end
  end

  defp deposit_action do
    Application.get_env(:bank_kata_ex, :actions) |> Map.get(:deposit)
  end

  defp withdraw_action do
    Application.get_env(:bank_kata_ex, :actions) |> Map.get(:withdraw)
  end
end

defmodule Bank.Delivery.WebAPI.PrintStatement do
  @moduledoc false

  use Plug.Router

  alias Plug.Conn.Status

  alias Bank.Core.Actions.Boundaries.PrintStatementInput

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: {Jason, :decode!, [[keys: :atoms]]}
  )

  plug(:dispatch)

  get "/" do
    account_id = conn.path_params["account_id"]
    action_input = %PrintStatementInput{account_id: account_id}
    {:ok, statement} = print_statement_action().execute(input: action_input)

    send_resp(conn, Status.code(:ok), statement)
  end

  defp print_statement_action do
    Application.get_env(:bank_kata_ex, :actions) |> Map.get(:print_statement)
  end
end

defmodule Bank.Delivery.WebAPI do
  @moduledoc false

  use Plug.Router

  alias Plug.Conn.Status
  alias Bank.Delivery.WebAPI.Transactions

  plug(:match)
  plug(Plug.RequestId)
  plug(:dispatch)

  forward("/api/bank/transactions", to: Transactions)
  forward("/api/bank/:account_id/statement", to: Bank.Delivery.WebAPI.PrintStatement)

  match _ do
    send_resp(
      conn,
      Status.code(:not_found),
      Jason.encode!(%{error: "NOT FOUND #{conn.request_path}"})
    )
  end

  def init(options) do
    options
  end
end
