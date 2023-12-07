calculate_calibration = fn line ->
  String.to_charlist(line)
  |> Enum.filter(&(&1 in ?0..?9))
  |> then(&[List.first(&1), List.last(&1)])
  |> to_string()
  |> Integer.parse()
  |> then(&elem(&1, 0))
end

sum_calibrations = fn lines -> Enum.reduce(lines, 0, &(calculate_calibration.(&1) + &2)) end

File.stream!("input.txt")
|> sum_calibrations.()
|> tap(&IO.puts("The sum of all calibration values is: #{&1}"))
