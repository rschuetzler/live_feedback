defmodule LiveFeedback.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveFeedback.Messages` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        anonymous_id: "some anonymous_id",
        content: "some content",
        is_anonymous: true,
        is_answered: true
      })
      |> LiveFeedback.Messages.create_message()

    message
  end
end
