class ApplicationController < ActionController::Base
  def current_user
    session_manager.current_user
  end
  helper_method :current_user

  def session_expires_at
    session_manager.session_expires_at
  end
  helper_method :session_expires_at

  def session_manager
    # the session being passed in here is the browser session, from the user cookie.
    @session_manager ||= SessionManager.new(session)
  end

  def login_user(user)
    session_manager.login_user(user)
  end

  def logout_user
    session_manager.logout_user
  end

  def current_user_has_voted?
    current_user&.has_voted?
  end
end
