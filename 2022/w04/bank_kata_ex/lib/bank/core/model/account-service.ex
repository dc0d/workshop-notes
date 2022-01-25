defmodule Bank.Core.Model.Account.Service do
  @moduledoc false

  @behaviour Bank.Core.Model.Account.Boundaries.Service

  alias Bank.Core.Model.Amount
  alias Bank.Core.Model.Account

  @spec deposit(account_id: String.t(), amount: Amount.t(), time: NaiveDateTime.t()) ::
          :ok | {:error, any()}
  def deposit(account_id: account_id, amount: %Amount{} = amount, time: %NaiveDateTime{} = time) do
    with {:ok, account} <- account_repo().load(account_id),
         {:ok, account} <- Account.deposit(account: account, amount: amount, time: time) do
      account_repo().save(account)
    else
      error ->
        {:error, error}
    end
  end

  @spec withdraw(account_id: String.t(), amount: Amount.t(), time: NaiveDateTime.t()) ::
          :ok | {:error, any()}
  def withdraw(account_id: account_id, amount: %Amount{} = amount, time: %NaiveDateTime{} = time) do
    with {:ok, account} <- account_repo().load(account_id),
         {:ok, account} <- Account.withdraw(account: account, amount: amount, time: time) do
      account_repo().save(account)
    else
      error ->
        {:error, error}
    end
  end

  @spec print_statement(account_id: String.t()) :: {:ok, String.t()} | {:error, any()}
  def print_statement(account_id: account_id) do
    with {:ok, account} <- account_repo().load(account_id),
         {:ok, statement} <- Account.print_statement(account: account) do
      {:ok, statement}
    else
      error ->
        {:error, error}
    end
  end

  defp account_repo do
    Application.get_env(:bank_kata_ex, :repos) |> Map.get(:account)
  end
end
