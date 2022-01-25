defmodule Bank.Tests.Support do
  @moduledoc false

  @spec parse_date(binary) :: NaiveDateTime.t()
  def parse_date(date_string) do
    [dd, mm, yyyy] = String.split(date_string, "-")

    [{day, _}, {month, _}, {year, _}] = [
      Integer.parse(dd, 10),
      Integer.parse(mm, 10),
      Integer.parse(yyyy, 10)
    ]

    {:ok, date} = Date.new(year, month, day)
    {:ok, time} = Time.new(0, 0, 0)
    {:ok, result} = NaiveDateTime.new(date, time)

    result
  end

  def get_result({:ok, result}) do
    result
  end

  def new_id do
    UUID.uuid4()
  end
end
