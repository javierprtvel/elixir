defmodule PaintByNumber do
  @empty_picture <<>>

  def palette_bit_size(color_count) do
    calculate_bit_size(color_count)
  end

  def empty_picture(), do: @empty_picture

  def test_picture(), do: <<0b00::2, 0b01::2, 0b10::2, 0b11::2>>

  def prepend_pixel(picture, color_count, pixel_color_index) do
    <<pixel_color_index::size(calculate_bit_size(color_count)), picture::bitstring>>
  end

  def get_first_pixel(@empty_picture, _color_count), do: nil

  def get_first_pixel(picture, color_count) do
    bit_size = calculate_bit_size(color_count)
    <<first_pixel::size(bit_size), _::bitstring>> = picture
    first_pixel
  end

  def drop_first_pixel(@empty_picture, _color_count), do: empty_picture()

  def drop_first_pixel(picture, color_count) do
    bit_size = calculate_bit_size(color_count)
    <<_first_pixel::size(bit_size), new_picture::bitstring>> = picture
    new_picture
  end

  def concat_pictures(picture1, picture2) do
    <<picture1::bitstring, picture2::bitstring>>
  end

  defp calculate_bit_size(color_count) do
    if color_count <= Integer.pow(2, 1), do: 1, else: calculate_bit_size(color_count, 2)
  end

  defp calculate_bit_size(color_count, n_bits) do
    if color_count <= Integer.pow(2, n_bits),
      do: n_bits,
      else: calculate_bit_size(color_count, n_bits + 1)
  end
end
