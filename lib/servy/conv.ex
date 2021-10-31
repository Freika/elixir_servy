defmodule Servy.Conv do
  defstruct method: "", path: "", resp_body: "", status_field: nil

  defmodule full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)""
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not found",
      500 => "Internal server error"
    }[code]
  end
end
