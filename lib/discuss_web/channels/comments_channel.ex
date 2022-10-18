defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  # socket is like the connection object in controllers;
  # it represents the entire lifecycle of the socket
  def join(name, _params, socket) do
    {:ok, %{"hello" => "world"}, socket}
  end

  def handle_in(name, message, socket) do
    IO.puts("+++++++++")
    IO.inspect(name)
    IO.inspect(message)
    IO.inspect(socket)
    {:reply, :ok, socket}
  end
end
