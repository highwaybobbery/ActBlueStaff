class SessionsController < ApplicationController
  # NOTE: Because there is no actual authentication protection or encryption,
  # password has been omitted entirely.

  def new
    @user = User.new
  end

  def create
    # This ensures that we find only by email address, but still allow the setting of zip code.
    @user = User.find_or_initialize_by(user_params.slice('email'))

    @user.assign_attributes(user_params)

    if @user.persisted?
      # login is guaranteed to save the user, so a separate save to capture a possible new zipcode is not needed.
      login_user(@user)

      if current_user_has_voted?
        redirect_to votes_url, notice: "You have already voted. Thanks for your participation!"
      else
        redirect_to new_vote_url, notice: "Welcome back! Please vote!"
      end
    else
      if @user.save
        login_user(@user)
        redirect_to new_vote_url, notice: "New voter registered."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if current_user.present?
      logout_user
    end
    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:email, :zipcode)
  end
end
