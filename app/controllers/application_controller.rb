class ApplicationController < ActionController::Base
  # NOTE: I've combined both view helpers and shared controller logic here, just to keep things a bit simpler.
  # I've kept all the view helpers at the top.

  def current_user
    session_manager.current_user
  end
  helper_method :current_user

  def session_expires_at
    session_manager.session_expires_at
  end
  helper_method :session_expires_at

  def caching_enabled?
    Rails.configuration.cache_store != :null_store
  end
  helper_method :caching_enabled?

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
