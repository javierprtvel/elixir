defmodule FileSniffer do
  def type_from_extension(extension) do
    case extension do
      "exe" -> "application/octet-stream"
      "bmp" -> "image/bmp"
      "png" -> "image/png"
      "jpg" -> "image/jpg"
      "gif" -> "image/gif"
      _ -> nil
    end
  end

  def type_from_binary(file_binary) do
    case file_binary do
      <<0x7F, 0x45, 0x4C, 0x46, _body::binary>> = _exe_bin_file ->
        type_from_extension("exe")

      <<0x42, 0x4D, _body::binary>> = _bmp_bin_file ->
        type_from_extension("bmp")

      <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _body::binary>> = _png_bin_file ->
        type_from_extension("png")

      <<0xFF, 0xD8, 0xFF, _body::binary>> = _jpg_bin_file ->
        type_from_extension("jpg")

      <<0x47, 0x49, 0x46, _body::binary>> = _gif_bin_file ->
        type_from_extension("gif")

      _ ->
        nil
    end
  end

  def verify(file_binary, extension) do
    type_from_binary = type_from_binary(file_binary)
    type_from_extension = type_from_extension(extension)

    cond do
      type_from_binary == nil or type_from_extension == nil ->
        {:error, "Warning, file format and file extension do not match."}

      type_from_binary != type_from_extension ->
        {:error, "Warning, file format and file extension do not match."}

      true ->
        {:ok, type_from_binary}
    end
  end
end
