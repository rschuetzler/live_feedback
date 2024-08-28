defmodule LiveFeedbackWeb.Router do
  use LiveFeedbackWeb, :router

  import LiveFeedbackWeb.UserAuth
  alias CoursePageLive.Index, as: CoursePageLive
  alias FeedbackLive.Index, as: FeedbackLive

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LiveFeedbackWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :assign_anonymous_id do
    plug LiveFeedbackWeb.Plugs.AssignAnonymousId
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveFeedbackWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveFeedbackWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:live_feedback, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LiveFeedbackWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", LiveFeedbackWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{LiveFeedbackWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", LiveFeedbackWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{LiveFeedbackWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
      live "/course_pages", CoursePageLive, :index
      live "/course_pages/new", CoursePageLive, :new
      live "/course_pages/:id/edit", CoursePageLive, :edit
      live "/course_pages/:id", CoursePageLive, :update
      live "/course_pages/:id/delete", CoursePageLive, :delete
    end
  end

  scope "/", LiveFeedbackWeb do
    pipe_through [:browser, :assign_anonymous_id]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{LiveFeedbackWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end

    live_session :feedback,
      on_mount: [{LiveFeedbackWeb.UserAuth, :mount_current_user}] do
      live "/page/:coursepage", FeedbackLive, :index
      live "/page/:coursepage/new", FeedbackLive, :new
    end
  end
end
