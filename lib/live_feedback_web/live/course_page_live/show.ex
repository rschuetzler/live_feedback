defmodule LiveFeedbackWeb.CoursePageLive.Show do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Courses

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:course_page, Courses.get_course_page!(id))}
  end

  defp page_title(:show), do: "Show Course page"
  defp page_title(:edit), do: "Edit Course page"
end
