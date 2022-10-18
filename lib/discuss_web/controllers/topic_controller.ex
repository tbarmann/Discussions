defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Repo

  alias Discuss.Discussions
  alias Discuss.Discussions.Topic

  # will only execute if one of these actions are passed to the controller
  plug(DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete])
  plug(:check_topic_owner when action in [:edit, :update, :delete])

  # def index(conn, _params) do
  #   topics = Discussions.list_topics()
  #   render(conn, "index.html", topics: topics)
  # end

  # def new(conn, _params) do
  #   changeset = Discussions.change_topic(%Topic{})
  #   render(conn, "new.html", changeset: changeset)
  # end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    # conn.assigns[:user]
    # conn.assigns.user

    # changeset = Topic.changeset(%Topic{}, topic)

    changeset =
      conn.assigns.user
      |> Ecto.build_assoc(:topics)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: old_topic)
    end
  end

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render(conn, "index.html", topics: topics)
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    render(conn, "show.html", topic: topic)
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id)
    |> Repo.delete!()

    conn
    |> put_flash(:info, "Topic deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  # def create(conn, %{"topic" => topic_params}) do
  #   case Discussions.create_topic(topic_params) do
  #     {:ok, topic} ->
  #       conn
  #       |> put_flash(:info, "Topic created successfully.")
  #       |> redirect(to: Routes.topic_path(conn, :show, topic))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   topic = Discussions.get_topic!(id)
  #   render(conn, "show.html", topic: topic)
  # end

  #   def edit(conn, %{"id" => id}) do
  #     topic = Discussions.get_topic!(id)
  #     changeset = Discussions.change_topic(topic)
  #     render(conn, "edit.html", topic: topic, changeset: changeset)
  #   end

  #   def update(conn, %{"id" => id, "topic" => topic_params}) do
  #     topic = Discussions.get_topic!(id)

  #     case Discussions.update_topic(topic, topic_params) do
  #       {:ok, topic} ->
  #         conn
  #         |> put_flash(:info, "Topic updated successfully.")
  #         |> redirect(to: Routes.topic_path(conn, :show, topic))

  #       {:error, %Ecto.Changeset{} = changeset} ->
  #         render(conn, "edit.html", topic: topic, changeset: changeset)
  #     end
  #   end

  #   def delete(conn, %{"id" => id}) do
  #     topic = Discussions.get_topic!(id)
  #     {:ok, _topic} = Discussions.delete_topic(topic)

  #     conn
  #     |> put_flash(:info, "Topic deleted successfully.")
  #     |> redirect(to: Routes.topic_path(conn, :index))
  #   end

  # params is not coming from router, need to get that info from conn
  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end
