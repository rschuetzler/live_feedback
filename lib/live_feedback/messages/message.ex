defmodule LiveFeedback.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :is_anonymous, :boolean, default: false
    field :anonymous_id, :string
    field :is_answered, :boolean, default: false
    field :user_id, :id
    field :course_page_id, :id
    field :vote_count, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [
      :content,
      :is_anonymous,
      :anonymous_id,
      :is_answered,
      :course_page_id,
      :vote_count
    ])
    |> validate_required([:content, :course_page_id])
  end
end
