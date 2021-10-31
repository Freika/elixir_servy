defmodule Servy.parser do
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
end
