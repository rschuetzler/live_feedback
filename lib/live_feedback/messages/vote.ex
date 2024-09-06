defmodule LiveFeedback.Messages.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    field :message_id, :id
    field :user_id, :id
    field :anonymous_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:message_id, :user_id, :anonymous_id])
    |> validate_required([:message_id])
    |> unique_constraint(:message_id, name: :votes_message_id_user_id_index)
    |> unique_constraint(:message_id, name: :votes_message_id_anonymous_id_index)
  end
end
