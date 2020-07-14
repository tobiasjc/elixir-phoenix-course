defmodule Discuss.Repo.Migrations.TopicsByUser do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
