defmodule LiveFeedbackWeb.CoursePageLiveTest do
  use LiveFeedbackWeb.ConnCase

  import Phoenix.LiveViewTest
  import LiveFeedback.CoursesFixtures

  @create_attrs %{description: "some description", title: "some title", slug: "some slug"}
  @update_attrs %{description: "some updated description", title: "some updated title", slug: "some updated slug"}
  @invalid_attrs %{description: nil, title: nil, slug: nil}

  defp create_course_page(_) do
    course_page = course_page_fixture()
    %{course_page: course_page}
  end

  describe "Index" do
    setup [:create_course_page]

    test "lists all course_pages", %{conn: conn, course_page: course_page} do
      {:ok, _index_live, html} = live(conn, ~p"/course_pages")

      assert html =~ "Listing Course pages"
      assert html =~ course_page.description
    end

    test "saves new course_page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/course_pages")

      assert index_live |> element("a", "New Course page") |> render_click() =~
               "New Course page"

      assert_patch(index_live, ~p"/course_pages/new")

      assert index_live
             |> form("#course_page-form", course_page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#course_page-form", course_page: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/course_pages")

      html = render(index_live)
      assert html =~ "Course page created successfully"
      assert html =~ "some description"
    end

    test "updates course_page in listing", %{conn: conn, course_page: course_page} do
      {:ok, index_live, _html} = live(conn, ~p"/course_pages")

      assert index_live |> element("#course_pages-#{course_page.id} a", "Edit") |> render_click() =~
               "Edit Course page"

      assert_patch(index_live, ~p"/course_pages/#{course_page}/edit")

      assert index_live
             |> form("#course_page-form", course_page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#course_page-form", course_page: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/course_pages")

      html = render(index_live)
      assert html =~ "Course page updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes course_page in listing", %{conn: conn, course_page: course_page} do
      {:ok, index_live, _html} = live(conn, ~p"/course_pages")

      assert index_live |> element("#course_pages-#{course_page.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#course_pages-#{course_page.id}")
    end
  end

  describe "Show" do
    setup [:create_course_page]

    test "displays course_page", %{conn: conn, course_page: course_page} do
      {:ok, _show_live, html} = live(conn, ~p"/course_pages/#{course_page}")

      assert html =~ "Show Course page"
      assert html =~ course_page.description
    end

    test "updates course_page within modal", %{conn: conn, course_page: course_page} do
      {:ok, show_live, _html} = live(conn, ~p"/course_pages/#{course_page}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Course page"

      assert_patch(show_live, ~p"/course_pages/#{course_page}/show/edit")

      assert show_live
             |> form("#course_page-form", course_page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#course_page-form", course_page: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/course_pages/#{course_page}")

      html = render(show_live)
      assert html =~ "Course page updated successfully"
      assert html =~ "some updated description"
    end
  end
end
