defmodule LibraryFees do
  @noon_hour 12
  @penalty_days_before_noon 28
  @penalty_days_after_noon 29
  @discount_rate 0.5

  def datetime_from_string(string) do
    {_, datetime} = NaiveDateTime.from_iso8601(string)
    datetime
  end

  def before_noon?(datetime) do
    datetime.hour < @noon_hour
  end

  def return_date(checkout_datetime) do
    days_to_add =
      if before_noon?(checkout_datetime),
        do: @penalty_days_before_noon,
        else: @penalty_days_after_noon

    NaiveDateTime.add(checkout_datetime, days_to_add, :day) |> NaiveDateTime.to_date()
  end

  def days_late(planned_return_date, actual_return_datetime) do
    actual_return_date = NaiveDateTime.to_date(actual_return_datetime)

    case Date.compare(planned_return_date, actual_return_date) do
      :eq -> 0
      :gt -> 0
      :lt -> Date.diff(actual_return_date, planned_return_date)
    end
  end

  def monday?(datetime) do
    NaiveDateTime.to_date(datetime) |> Date.day_of_week() == 1
  end

  def calculate_late_fee(checkout, return, rate) do
    checkout_datetime = datetime_from_string(checkout)
    actual_return_datetime = datetime_from_string(return)
    planned_return_date = return_date(checkout_datetime)
    days_late = days_late(planned_return_date, actual_return_datetime)

    if monday?(actual_return_datetime) do
      trunc(rate * days_late * @discount_rate)
    else
      rate * days_late
    end
  end
end
