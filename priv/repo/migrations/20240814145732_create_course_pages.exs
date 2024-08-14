defmodule LiveFeedback.Repo.Migrations.CreateCoursePages do
  use Ecto.Migration

  def change do
    create table(:course_pages) do
      add :title, :string
      add :description, :text
      add :slug, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:course_pages, [:slug])
    create index(:course_pages, [:user_id])
  end
end
