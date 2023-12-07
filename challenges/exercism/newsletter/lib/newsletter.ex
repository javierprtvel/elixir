defmodule Newsletter do
  def read_emails(path) do
    File.read!(path)
    |> String.split(~r/\n|\r\n/)
    |> Enum.reject(&(&1 === ""))
  end

  def open_log(path) do
    File.open!(path, [:write])
  end

  def log_sent_email(pid, email) do
    IO.binwrite(pid, "#{email}\n")
  end

  def close_log(pid) do
    File.close(pid)
  end

  def send_newsletter(emails_path, log_path, send_fun) do
    log_pid = open_log(log_path)

    read_emails(emails_path)
    |> Enum.each(&if send_fun.(&1) === :ok, do: log_sent_email(log_pid, &1))

    close_log(log_pid)
  end
end
