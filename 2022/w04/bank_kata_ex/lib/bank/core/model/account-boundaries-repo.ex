defmodule Bank.Core.Model.Account.Boundaries.Repo do
  @moduledoc false

  alias Bank.Core.Model.Account

  @type reason :: any()

  @callback load(account_id: String.t()) :: {:ok, Account.t()} | {:error, reason()}
  @callback save(account: Account.t()) :: :ok | {:error, reason()}
end
