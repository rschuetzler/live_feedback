defmodule LiveFeedbackWeb.CoursePageLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Courses
  alias LiveFeedback.Courses.CoursePage

  @impl true
  def mount(_params, _session, socket) do
    if socket.assigns.current_user.is_admin do
      {:ok, stream(socket, :course_pages, Courses.list_course_pages())}
    else
      {:ok,
       stream(
         socket,
         :course_pages,
         Courses.list_course_pages_by_user(socket.assigns.current_user.id)
       )}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Feedback page")
    |> assign(:course_page, Courses.get_course_page!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Feedback page")
    |> assign(:course_page, %CoursePage{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Feedback pages")
    |> assign(:course_page, nil)
  end

  @impl true
  def handle_info({LiveFeedbackWeb.CoursePageLive.FormComponent, {:saved, course_page}}, socket) do
    {:noreply, stream_insert(socket, :course_pages, course_page)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    course_page = Courses.get_course_page!(id)
    {:ok, _} = Courses.delete_course_page(course_page)

    {:noreply, stream_delete(socket, :course_pages, course_page)}
  end
end
