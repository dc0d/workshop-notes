defmodule Bank.Tests.Support.FakeAccountRepo do
  @moduledoc false

  use Agent
  @behaviour Bank.Core.Model.Account.Boundaries.Repo

  @name __MODULE__

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: @name)
  end

  def load(account_id: account_id) do
    Agent.get(@name, fn data ->
      case Map.get(data, account_id, :account_not_found) do
        :account_not_found -> {:error, :account_not_found}
        account -> {:ok, account}
      end
    end)
  end

  def save(account: account) do
    Agent.update(@name, fn data -> Map.put(data, account.account_id, account) end)
    :ok
  end
end
