defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  alias Discuss.Repo
  alias Discuss.Discussions.Topic

  # socket is like the connection object in controllers;
  # it represents the entire lifecycle of the socket
  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)

    topic = Repo.get(Topic, topic_id)

    {:ok, %{topic: topic.title}, socket}
  end

  def handle_in(name, message, socket) do
    {:reply, :ok, socket}
  end
end
