defmodule LiveFeedback.Repo.Migrations.UpdateUserIdOnDeleteCascade do
  use Ecto.Migration

  def change do
    alter table(:course_pages) do
      modify :user_id, references(:users, on_delete: :delete_all),
        from: references(:users, on_delete: :nothing)
    end
  end
end
