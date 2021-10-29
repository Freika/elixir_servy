defmodule Servy.Handler do
  def handle(request) do
    request
      |> parse
      |> rewrite_path
      |> log
      |> route
      |> track
      |> format_response
  end

  def track(%{ status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} is not found")
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{ path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect(conv)

  def parse(request) do
    [method, path, _] =     # assign resulting variables splitted by space symbol
      request
      |> String.split("\n") # split by \n
      |> List.first         # get first line
      |> String.split(" ")  # split by space symbol

    %{
      method: method,
      path: path,
      resp_body: "",
      status: nil
    }
  end

  # def route(conv) do
  #   route(conv, conv.method, conv.path)
  # end
  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions and Tigers" }
  end

  def route(%{ method: "GET", path: "/bears" } = conv) do
    %{ conv | status: 200, resp_body: "Teddy, Smokey" }
  end

  def route(%{ method: "GET", path: "/bears/" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def route(%{path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!" }
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}
    #{conv.resp_body}
    """
  end

  defp status_reasun(code) do
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
