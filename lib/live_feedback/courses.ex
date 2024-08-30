defmodule LiveFeedback.Courses do
  @moduledoc """
  The Courses context.
  """

  import Ecto.Query, warn: false
  alias LiveFeedback.Repo

  alias LiveFeedback.Courses.CoursePage

  @doc """
  Returns the list of course_pages.

  ## Examples

      iex> list_course_pages()
      [%CoursePage{}, ...]

  """
  def list_course_pages do
    Repo.all(CoursePage)
  end

  @doc """
  Gets a single course_page.

  Raises `Ecto.NoResultsError` if the Course page does not exist.

  ## Examples

      iex> get_course_page!(123)
      %CoursePage{}

      iex> get_course_page!(456)
      ** (Ecto.NoResultsError)

  """
  def get_course_page!(id), do: Repo.get!(CoursePage, id)

  @doc """
  Creates a course_page.

  ## Examples

      iex> create_course_page(%{field: value})
      {:ok, %CoursePage{}}

      iex> create_course_page(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_course_page(attrs \\ %{}) do
    %CoursePage{}
    |> CoursePage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a course_page.

  ## Examples

      iex> update_course_page(course_page, %{field: new_value})
      {:ok, %CoursePage{}}

      iex> update_course_page(course_page, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_course_page(%CoursePage{} = course_page, attrs) do
    course_page
    |> CoursePage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a course_page.

  ## Examples

      iex> delete_course_page(course_page)
      {:ok, %CoursePage{}}

      iex> delete_course_page(course_page)
      {:error, %Ecto.Changeset{}}

  """
  def delete_course_page(%CoursePage{} = course_page) do
    Repo.delete(course_page)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking course_page changes.

  ## Examples

      iex> change_course_page(course_page)
      %Ecto.Changeset{data: %CoursePage{}}

  """
  def change_course_page(%CoursePage{} = course_page, attrs \\ %{}) do
    CoursePage.changeset(course_page, attrs)
  end

  def get_course_page_by_slug!(slug) do
    Repo.get_by(CoursePage, slug: slug)
  end

  def list_course_pages_by_user(user_id) do
    Repo.all(from cp in CoursePage, where: cp.user_id == ^user_id)
  end
end
