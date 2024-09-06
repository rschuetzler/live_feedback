defmodule LiveFeedbackWeb.CoursePageLive.FormComponent do
  use LiveFeedbackWeb, :live_component

  alias LiveFeedback.Courses

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Manage your feedback pages</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="course_page-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:slug]} type="text" label="Slug (this goes into the URL)" />
        <.input field={@form[:allows_voting]} type="checkbox" label="Allow voting?" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Feedback page</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{course_page: course_page} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Courses.change_course_page(course_page))
     end)}
  end

  @impl true
  def handle_event("validate", %{"course_page" => course_page_params}, socket) do
    changeset = Courses.change_course_page(socket.assigns.course_page, course_page_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"course_page" => course_page_params}, socket) do
    save_course_page(socket, socket.assigns.action, course_page_params)
  end

  defp save_course_page(socket, :edit, course_page_params) do
    case Courses.update_course_page(socket.assigns.course_page, course_page_params) do
      {:ok, course_page} ->
        notify_parent({:saved, course_page})

        {:noreply,
         socket
         |> put_flash(:info, "Feedback page updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_course_page(socket, :new, course_page_params) do
    user = socket.assigns.current_user

    course_page_params = Map.put_new(course_page_params, "user_id", user.id)

    case Courses.create_course_page(course_page_params) do
      {:ok, course_page} ->
        notify_parent({:saved, course_page})

        {:noreply,
         socket
         |> put_flash(:info, "Feedback page created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
