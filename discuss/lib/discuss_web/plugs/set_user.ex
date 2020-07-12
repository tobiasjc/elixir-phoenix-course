defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn

  def init(_params), do: nil

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Discuss.Repo.get(Discuss.User, user_id) ->
        assign(conn, :user, user)

      true ->
        assign(conn, :user, nil)
    end
  end
end
