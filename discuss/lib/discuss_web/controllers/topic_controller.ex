defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _attrs) do
    changeset = Discuss.Topic.changeset(%Discuss.Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _attrs) do
    topics = Discuss.Repo.all(Discuss.Topic)
    render(conn, "index.html", topics: topics)
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"id" => topic_id}) do
    try do
      topic = Discuss.Repo.get!(Discuss.Topic, topic_id)
      changeset = Discuss.Topic.changeset(topic, %{})
      render(conn, "edit.html", changeset: changeset, topic: topic)
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_flash(
          :error,
          "Wasn't possible to find the topic with id equals \"#{topic_id}\"."
        )
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t()
  def delete(conn, %{"id" => topic_id}) do
    Discuss.Repo.get!(Discuss.Topic, topic_id) |> Discuss.Repo.delete!()

    conn
    |> put_flash(:info, "Topic Successfully Deleted!")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t()
  def update(conn, %{"id" => topic_id, "topic" => new_topic}) do
    old_topic = Discuss.Repo.get!(Discuss.Topic, topic_id)
    changeset = Discuss.Topic.changeset(old_topic, new_topic)

    try do
      Discuss.Repo.update!(changeset)

      conn
      |> put_flash(:info, "Topic Successfully Updated!")
      |> redirect(to: Routes.topic_path(conn, :index))
    rescue
      e in Ecto.InvalidChangesetError ->
        render(conn, "edit.html", changeset: e.changeset, topic: old_topic)
    end
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()

  def create(conn, %{"topic" => topic}) do
    changeset = Discuss.Topic.changeset(%Discuss.Topic{}, topic)

    try do
      Discuss.Repo.insert!(changeset)

      conn
      |> put_flash(:info, "Topic Created!")
      |> redirect(to: Routes.topic_path(conn, :index))
    rescue
      e in Ecto.InvalidChangesetError -> render(conn, "new.html", changeset: e.changeset)
    end
  end
end
