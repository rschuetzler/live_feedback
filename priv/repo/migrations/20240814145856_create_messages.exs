defmodule LiveFeedback.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :text
      add :is_anonymous, :boolean, default: false, null: false
      add :anonymous_id, :string
      add :is_answered, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all)
      add :course_page_id, references(:course_pages, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:user_id])
    create index(:messages, [:course_page_id])
  end
end
