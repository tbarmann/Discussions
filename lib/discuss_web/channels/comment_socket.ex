defmodule DiscussWeb.CommentSocket do
  use Phoenix.Socket

  channel("comments:*", DiscussWeb.CommentsChannel)

  # transport(:websocket, Phoenix.Transports.WebSocket)

  @impl true
  # key is string because it is being sent in json
  # so pattern match has quotes around it
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "key", token) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}

      {:error, error} ->
        :error
    end
  end

  @impl true
  def id(_socket), do: nil
end
