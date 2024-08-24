defmodule LiveFeedbackWeb.FeedbackLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Messages
  alias LiveFeedback.Courses.CoursePage
  alias LiveFeedback.Courses
  alias LiveFeedback.Messages.Message

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :course_pages, Courses.list_course_pages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"coursepage" => coursepage}) do
    course_page = Courses.get_course_page_by_slug!(coursepage)
    socket
    |> assign(:page_title, "Live Feedback")
    |> assign(:course_page, course_page)
    |> assign(:messages, Messages.get_messages_for_course_page_id(course_page.id))
  end

  # defp apply_action(socket, :index, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Course page")
  #   |> assign(:course_page, Courses.get_course_page!(id))
  # end

  defp apply_action(socket, :new, %{"coursepage" => coursepage}) do
    socket
    |> assign(:page_title, "New Message")
    |> assign(:course_page, Courses.get_course_page_by_slug!(coursepage))
    |> assign(:message, %Message{})
  end
end
