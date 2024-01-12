class IndexController < ApplicationController

  # GET /users or /users.json
  def index
    # This logic would ideally be moved to the front end as a single page application
    if current_user
      if current_user_has_voted?
        redirect_to votes_url, notice: 'You have already voted. Thanks for your participation!'
      else
        redirect_to new_vote_url, notice: 'Please Vote!'
      end
    else
      redirect_to new_session_url
    end
  end
end
