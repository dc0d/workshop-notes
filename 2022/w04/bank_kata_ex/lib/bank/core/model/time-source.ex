defmodule Bank.Core.Model.Boundaries.TimeSource do
  @moduledoc false

  @callback utc() :: NaiveDateTime.t()
end
