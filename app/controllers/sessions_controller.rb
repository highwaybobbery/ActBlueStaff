class SessionsController < ApplicationController
  # NOTE: Because there is no actual authentication protection or encryption,
  # password has been omitted entirely.

  def new
    @user = User.new
  end

  def create
    @user = User.find_or_initialize_by(user_params)

    if @user.persisted?
      login_user

      if current_user.has_voted?
        redirect_to votes_url, notice: "You have already voted. Thanks for your participation!"
      else
        redirect_to new_vote_url, notice: "Welcome back! Please vote!"
      end
    else
      if @user.save
        login_user
        redirect_to new_vote_url, notice: "New voter registered."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if current_user.present?
      logout_user
      redirect_to root_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
