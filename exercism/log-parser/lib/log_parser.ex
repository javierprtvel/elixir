defmodule LogParser do
  def valid_line?(line) do
    line =~ ~r/^\[DEBUG|INFO|WARNING|ERROR\]/
  end

  def split_line(line) do
    String.split(line, ~r/<[~*=-]*>/)
  end

  def remove_artifacts(line) do
    String.replace(line, ~r/end-of-line\d+/i, "")
  end

  def tag_with_user_name(line) do
    user_regex = ~r/user\s+(\S+)/iu
    regex_result = Regex.run(user_regex, line)

    case regex_result do
      nil -> line
      [_match, user_name] -> "[USER] #{user_name} #{line}"
    end
  end
end
