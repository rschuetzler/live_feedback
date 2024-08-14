defmodule LiveFeedback.CoursesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveFeedback.Courses` context.
  """

  @doc """
  Generate a unique course_page slug.
  """
  def unique_course_page_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a course_page.
  """
  def course_page_fixture(attrs \\ %{}) do
    {:ok, course_page} =
      attrs
      |> Enum.into(%{
        description: "some description",
        slug: unique_course_page_slug(),
        title: "some title"
      })
      |> LiveFeedback.Courses.create_course_page()

    course_page
  end
end
