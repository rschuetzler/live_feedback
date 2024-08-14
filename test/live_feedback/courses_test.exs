defmodule LiveFeedback.CoursesTest do
  use LiveFeedback.DataCase

  alias LiveFeedback.Courses

  describe "course_pages" do
    alias LiveFeedback.Courses.CoursePage

    import LiveFeedback.CoursesFixtures

    @invalid_attrs %{description: nil, title: nil, slug: nil}

    test "list_course_pages/0 returns all course_pages" do
      course_page = course_page_fixture()
      assert Courses.list_course_pages() == [course_page]
    end

    test "get_course_page!/1 returns the course_page with given id" do
      course_page = course_page_fixture()
      assert Courses.get_course_page!(course_page.id) == course_page
    end

    test "create_course_page/1 with valid data creates a course_page" do
      valid_attrs = %{description: "some description", title: "some title", slug: "some slug"}

      assert {:ok, %CoursePage{} = course_page} = Courses.create_course_page(valid_attrs)
      assert course_page.description == "some description"
      assert course_page.title == "some title"
      assert course_page.slug == "some slug"
    end

    test "create_course_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_course_page(@invalid_attrs)
    end

    test "update_course_page/2 with valid data updates the course_page" do
      course_page = course_page_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", slug: "some updated slug"}

      assert {:ok, %CoursePage{} = course_page} = Courses.update_course_page(course_page, update_attrs)
      assert course_page.description == "some updated description"
      assert course_page.title == "some updated title"
      assert course_page.slug == "some updated slug"
    end

    test "update_course_page/2 with invalid data returns error changeset" do
      course_page = course_page_fixture()
      assert {:error, %Ecto.Changeset{}} = Courses.update_course_page(course_page, @invalid_attrs)
      assert course_page == Courses.get_course_page!(course_page.id)
    end

    test "delete_course_page/1 deletes the course_page" do
      course_page = course_page_fixture()
      assert {:ok, %CoursePage{}} = Courses.delete_course_page(course_page)
      assert_raise Ecto.NoResultsError, fn -> Courses.get_course_page!(course_page.id) end
    end

    test "change_course_page/1 returns a course_page changeset" do
      course_page = course_page_fixture()
      assert %Ecto.Changeset{} = Courses.change_course_page(course_page)
    end
  end
end
