defmodule LiveFeedback.Repo.Migrations.AddVoting do
  use Ecto.Migration

  def change do
    alter table(:course_pages) do
      add :allows_voting, :boolean, default: false
    end

    create table(:votes) do
      add :message_id, references(:messages, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
      add :anonymous_id, :string
      timestamps()
    end

    create unique_index(:votes, [:message_id, :user_id])
    create unique_index(:votes, [:message_id, :anonymous_id])

    alter table(:messages) do
      add :vote_count, :integer, default: 0
    end
  end
end
