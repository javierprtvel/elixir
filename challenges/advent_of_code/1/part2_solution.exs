digit_name_regex = ~r/one|two|three|four|five|six|seven|eight|nine/

# In order to cover overlapping digit names cases (e.g. "sdfoneight56"), we replace the digit name with
# a digit string containing the first and the last letter of the name and the actual digit between them.
# Then executing the replacement twice is enough to ensure every digit name is processed.
digit_name_to_safe_digit_str = %{
  "one" => "o1e",
  "two" => "t2o",
  "three" => "t3e",
  "four" => "f4r",
  "five" => "f5e",
  "six" => "s6x",
  "seven" => "s7n",
  "eight" => "e8t",
  "nine" => "n9e"
}

replace_spelled_out_digits_by_digits = fn line ->
  line
  |> String.replace(digit_name_regex, &digit_name_to_safe_digit_str[&1])
  |> String.replace(digit_name_regex, &digit_name_to_safe_digit_str[&1])
end

first_and_last_digits = fn chars ->
  chars
  |> String.to_charlist()
  |> Enum.filter(&(&1 in ?0..?9))
  |> then(&[List.first(&1), List.last(&1)])
  |> to_string()
end

calculate_calibration = fn line ->
  line
  |> replace_spelled_out_digits_by_digits.()
  |> first_and_last_digits.()
  |> Integer.parse()
  |> then(&elem(&1, 0))
end

sum_calibrations = fn lines ->
  Enum.reduce(lines, 0, &(calculate_calibration.(&1) + &2))
end

File.stream!("input.txt")
|> sum_calibrations.()
|> tap(&IO.puts("The sum of all calibration values is: #{&1}"))
