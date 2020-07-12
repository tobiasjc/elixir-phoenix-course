defmodule DiscussWeb.Plugs.RequireAuth do
  use DiscussWeb, :controller

  def init(_params), do: nil

  def call(conn, _params) do
    cond do
      conn.assigns[:user] != nil ->
        conn

      true ->
        conn
        |> put_flash(:error, "You do not have permission to access this resource.")
        |> redirect(to: Routes.topic_path(conn, :index))
        |> halt()
    end
  end
end
