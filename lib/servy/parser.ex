defmodule Servy.parser do

  alias Servy.Conv

  def parse(request) do
    [method, path, _] =     # assign resulting variables splitted by space symbol
      request
      |> String.split("\n") # split by \n
      |> List.first         # get first line
      |> String.split(" ")  # split by space symbol

    %Conv{
      method: method,
      path: path
    }
  end
end
