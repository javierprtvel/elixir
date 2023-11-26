defmodule NameBadge do
  def print(id, name, department) do
    department = if department != nil, do: String.upcase(department), else: "OWNER"
    id_prefix = if id != nil, do: "[#{id}] - ", else: ""
    "#{id_prefix}#{name} - #{department}"
  end
end
