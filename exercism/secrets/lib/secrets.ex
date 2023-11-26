defmodule Secrets do
  def secret_add(secret), do: &(secret + &1)

  def secret_subtract(secret), do: &(&1 - secret)

  def secret_multiply(secret), do: &(secret * &1)

  def secret_divide(secret), do: fn dividend -> div(dividend, secret) end

  def secret_and(secret), do: fn other -> Bitwise.band(secret, other) end

  def secret_xor(secret), do: &Bitwise.bxor(&1, secret)

  def secret_combine(secret_function1, secret_function2),
    do: &secret_function2.(secret_function1.(&1))
end
