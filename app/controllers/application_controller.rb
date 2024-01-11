class ApplicationController < ActionController::Base
  def current_user
    if @_current_user ||= session[:current_user_id] && User.find_by(id: session[:current_user_id])
      if @_current_user.logged_in_at < Time.now - 5.minutes
        logout_user
      end
    end
    @_current_user
  end

  helper_method :current_user

  def login_user
    @user.update!(logged_in_at: Time.now)
    session[:current_user_id] = @user.id
    @_current_user = @user
  end

  def logout_user
    @_current_user = nil
    session.delete(:current_user_id)
  end
end
