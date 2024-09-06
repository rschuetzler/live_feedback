defmodule LiveFeedback.Courses.CoursePage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "course_pages" do
    field :description, :string
    field :title, :string
    field :slug, :string
    field :user_id, :id
    field :allows_voting, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(course_page, attrs) do
    course_page
    |> cast(attrs, [:title, :description, :slug, :user_id, :allows_voting])
    |> validate_required([:title, :description, :slug])
    |> unique_constraint(:slug)
  end
end
