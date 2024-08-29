defmodule LiveFeedbackWeb.FeedbackLive.FormComponent do
  use LiveFeedbackWeb, :live_component

  alias LiveFeedback.Messages

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Ask a question, make a comment, or whatever you need</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="message-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:content]} type="text" label="Enter your message" />
        <input type="hidden" name="message[course_page_id]" value={@course_page.id} />
        <:actions>
          <.button phx-disable-with="Saving...">Post Message</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{message: message, course_page: course_page} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:course_page, course_page)
     |> assign_new(:form, fn ->
       to_form(Messages.change_message(message))
     end)}
  end

  @impl true
  def handle_event("validate", %{"message" => message_params}, socket) do
    changeset = Messages.change_message(socket.assigns.message, message_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    # IO.inspect(socket.assigns)

    message_params = Map.put(message_params, "anonymous_id", socket.assigns.anonymous_id)
    save_message(socket, socket.assigns.action, message_params)
  end

  defp save_message(socket, :edit, message_params) do
    case Messages.update_message(socket.assigns.message, message_params) do
      {:ok, message} ->
        notify_parent({:saved, message})

        {:noreply,
         socket
         |> put_flash(:info, "Message updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_message(socket, :new, message_params) do
    case Messages.create_message(message_params) do
      {:ok, message} ->
        notify_parent({:saved, message})

        {:noreply,
         socket
         |> put_flash(:info, "Message created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
