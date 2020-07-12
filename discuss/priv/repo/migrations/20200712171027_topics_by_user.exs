defmodule Discuss.Repo.Migrations.TopicsByUser do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      add :user_id, references(:users, [column: :id, on_delete: :delete_all, on_update: :update_all])
    end
  end
end
