defmodule LiveFeedbackWeb.FeedbackLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Messages
  alias LiveFeedback.Courses
  alias LiveFeedback.Messages.Message

  @impl true
  def mount(%{"coursepage" => coursepageid}, _session, socket) do
    course_page = Courses.get_course_page_by_slug!(coursepageid)

    if connected?(socket), do: Messages.subscribe()

    {:ok,
     stream(
       socket,
       :messages,
       Messages.get_messages_for_course_page_id(course_page.id)
     )}
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

  @impl true
  def handle_event("delete_all_messages", _params, socket) do
    if socket.assigns.current_user.is_admin do
      Messages.delete_all_messages_for_course_page(socket.assigns.course_page)
      {:noreply, stream(socket, :messages, [], reset: true)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:new_message, message}, socket) do
    if message.course_page_id == socket.assigns.course_page.id do
      {:noreply, stream_insert(socket, :messages, message)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({LiveFeedbackWeb.FeedbackLive.FormComponent, {:saved, _message}}, socket) do
    # if message.course_page_id == socket.assigns.course_page.id do
    #   updated_messages = [message | socket.assigns.messages]
    #   {:noreply, stream(socket, :messages, updated_messages)}
    # else
    {:noreply, socket}
    # end
  end
end
