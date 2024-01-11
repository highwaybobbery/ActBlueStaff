class ApplicationController < ActionController::Base

  def session_manager
    @session_manager ||= SessionManager.new(session)
  end

  def current_user
    session_manager.current_user
  end

  helper_method(:current_user)

  def login_user(user)
    session_manager.login_user(user)
  end

  def logout_user
    session_manager.logout_user
  end
  # delegate :current_user, :login_user, :logout_user, to: session_manager
end
