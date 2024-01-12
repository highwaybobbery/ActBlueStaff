class SessionManager
  SESSION_LENGTH_IN_SECONDS = 300
  SESSION_USER_ID_KEY = :user_id

  attr_reader :current_user

  def initialize(session)
    @session = session

    validate_session
  end

  def login_user(user)
    set_session_user_id(user.id)
    user.update!(logged_in_at: Time.now)
    self.current_user = user
  end

  def logout_user
    return unless current_user

    current_user.update!(logged_in_at: nil)
    clear_session_user_id
    self.current_user = nil
  end

  def session_expires_at
    return unless current_user
    current_user.logged_in_at + SESSION_LENGTH_IN_SECONDS.seconds
  end

  private

  attr_writer :current_user

  # NOTE: This implementation relies on short transactions to ensure
  # that the login has not timed out. Validation would need to be reworked to
  # offer protection during multi-second transactions.
  def validate_session
    return unless session_user_id.present?

    user = User.find(session_user_id)
    if user.logged_in_at < Time.now - SESSION_LENGTH_IN_SECONDS.seconds
      clear_session_user_id
    else
      self.current_user = user
    end
  end

  # NOTE: Because we are dealing with the raw session, these methods ensure that we are
  # only manipulating the session in very specific ways. Do not access the session directly in other
  # methods!
  def session_user_id
    @session[SESSION_USER_ID_KEY]
  end

  def set_session_user_id(user_id)
    @session[SESSION_USER_ID_KEY] = user_id
  end

  def clear_session_user_id
    @session.delete(SESSION_USER_ID_KEY)
  end
end
