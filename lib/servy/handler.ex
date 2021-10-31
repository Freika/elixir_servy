defmodule Servy.Handler do

  alias Servy.Conv

  @moduledoc """
  Handles HTTP requests.
  """

  @pages_path Path.expand("pages", File.cwd!)

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]

  @doc "Transforms request into response"
  def handle(request) do
    request
      |> parse
      |> rewrite_path
      |> log
      |> route
      |> track
      |> format_response
  end

  def route(%Conv{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions and Tigers" }
  end

  def route(%Conv{ method: "GET", path: "/bears" } = conv) do
    %{ conv | status: 200, resp_body: "Teddy, Smokey" }
  end

  def route(%Conv{ method: "GET", path: "/bears/" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def route(%Conv{ method: "GET", path: "/about.html" } = conv) do
    @pages_path
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
  end

  def handle_file({:ok, content}, conv) do
    %{ conv | status: 200, resp_body: content }
  end

  def handle_file({ :error, :enoent }, conv) do
    %{ conv | status: 404, resp_body: "File not found" }
  end

  def handle_file({ :error, reason }, conv) do
    %{ conv | status: 404, resp_body: "File error: #{reason} "}
  end

  def route(%{path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!" }
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{%Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}
    #{conv.resp_body}
    """
  end
end
