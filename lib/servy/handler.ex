defmodule Servy.Handler do
  def handle(request) do
    request
      |> parse
      |> log
      |> route
      |> format_response
  end

  def log(conv), do: IO.inspect(conv)

  def parse(request) do
    [method, path, _] =     # assign resulting variables splitted by space symbol
      request
      |> String.split("\n") # split by \n
      |> List.first         # get first line
      |> String.split(" ")  # split by space symbol

    %{ method: method, path: path, resp_body: "" }
  end

  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/wildthings") do
    %{ conv | resp_body: "Bears, Lions and Tigers" }
  end

  def route(conv, "GET", "/bears") do
    %{ conv | resp_body: "Teddy, Smokey" }
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}
    #{conv.resp_body}
    """
  end
end
