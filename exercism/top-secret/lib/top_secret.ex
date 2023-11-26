defmodule TopSecret do
  def to_ast(string) do
    {:ok, ast} = Code.string_to_quoted(string)
    ast
  end

  def decode_secret_message_part({op, _meta, children_ast} = ast, acc) do
    new_acc =
      cond do
        op === :def or op === :defp ->
          decoded_msg_part = find_function_ast(children_ast) |> decode_function_ast()
          [decoded_msg_part | acc]

        true ->
          acc
      end

    {ast, new_acc}
  end

  def decode_secret_message_part(ast, acc), do: {ast, acc}

  def decode_secret_message(string) do
    string
    |> to_ast()
    |> Macro.prewalk([], &decode_secret_message_part/2)
    |> then(fn {_ast, acc} -> acc end)
    |> Enum.reverse()
    |> Enum.join("")
  end

  defp find_function_ast(ast_list) do
    [head_ast | _tail_ast] = ast_list

    if elem(head_ast, 0) === :when do
      find_function_ast(elem(head_ast, 2))
    else
      head_ast
    end
  end

  defp decode_function_ast(func_ast) do
    {func_name, _meta, args} = func_ast

    arity =
      case is_list(args) do
        true -> length(args)
        false -> 0
      end

    Atom.to_string(func_name) |> String.slice(0, arity)
  end
end
