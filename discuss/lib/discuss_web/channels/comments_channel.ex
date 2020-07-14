defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  def join("comments:" <> topic_id, _message, socket) do
    topic_id = String.to_integer(topic_id)

    topic =
      Discuss.Topic
      |> Discuss.Repo.get(topic_id)
      |> Discuss.Repo.preload(comments: :user)

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns[:topic]
    user_id = socket.assigns[:user_id]

    changeset =
      topic
      |> Ecto.build_assoc(:comments, user_id: user_id)
      |> Discuss.Comment.changeset(%{content: content})

    case Discuss.Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(
          socket,
          "comments:#{socket.assigns.topic.id}:new",
          %{comment: Discuss.Repo.preload(comment, :user)}
        )

        {:reply, :ok, socket}

      {:error, reason} ->
        {:reply, {:error, %{errors: changeset, reason: reason}}, socket}
    end
  end
end
