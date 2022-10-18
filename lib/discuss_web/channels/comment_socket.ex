defmodule DiscussWeb.CommentSocket do
  use Phoenix.Socket

  channel("comments:*", DiscussWeb.CommentsChannel)

  # transport(:websocket, Phoenix.Transports.WebSocket)

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
