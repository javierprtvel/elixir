defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception(value) do
      case value do
        [] -> %StackUnderflowError{}
        _ -> %StackUnderflowError{message: "stack underflow occurred, context: #{value}"}
      end
    end
  end

  def divide([]) do
    raise StackUnderflowError, "when dividing"
  end

  def divide([_]) do
    raise StackUnderflowError, "when dividing"
  end

  def divide([divisor | [dividend | _]]) do
    if divisor === 0 do
      raise DivisionByZeroError
    end

    dividend / divisor
  end
end
