defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  def new(conn, _attr) do
    changeset = Discuss.Topic.changeset(%Discuss.Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do

  end
end
