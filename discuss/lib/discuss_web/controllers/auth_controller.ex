defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, attrs) do
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: attrs["provider"]
    }

    changeset = Discuss.User.changeset(%Discuss.User{}, user_params)

    sign_in(conn, changeset)
  end

  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Error signing in.")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Discuss.Repo.get_by(Discuss.User, email: changeset.changes.email) do
      nil -> Discuss.Repo.insert(changeset)
      user -> {:ok, user}
    end
  end
end
