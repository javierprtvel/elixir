defmodule DNA do
  @nucleotide_bitsize 4

  def encode_nucleotide(code_point) do
    case code_point do
      ?\s -> 0
      ?A -> 0b1
      ?C -> 0b10
      ?G -> 0b100
      ?T -> 0b1000
    end
  end

  def decode_nucleotide(encoded_code) do
    case encoded_code do
      0 -> ?\s
      0b1 -> ?A
      0b10 -> ?C
      0b100 -> ?G
      0b1000 -> ?T
    end
  end

  def encode(dna) do
    encoded_dna = <<>>
    do_encode(encoded_dna, dna)
  end

  def decode(dna) do
    decoded_dna = ~c""
    do_decode(decoded_dna, dna)
  end

  defp do_encode(encoded_dna, []), do: encoded_dna

  defp do_encode(encoded_dna, [nucleotide | dna]) do
    do_encode(
      <<encoded_dna::bitstring, encode_nucleotide(nucleotide)::@nucleotide_bitsize>>,
      dna
    )
  end

  defp do_decode(decoded_dna, <<>>), do: decoded_dna

  defp do_decode(
         decoded_dna,
         <<encoded_nucleotide::@nucleotide_bitsize, encoded_dna::bitstring>>
       ) do
    do_decode(
      decoded_dna ++ [decode_nucleotide(encoded_nucleotide)],
      encoded_dna
    )
  end
end
