class VotesController < ApplicationController
  def index
    @votes = Vote.cached_votes_by_candidate
  end

  def new
    if current_user.blank?
      redirect_to new_session_url, notice: "Please Sign In to Vote!"
    end

    if current_user_has_voted?
      redirect_to action: :index, notice: "You have already voted. Thanks for your participation!"
    end

    @candidates = Candidate.all
    @write_in_candidate = Candidate.new
    @max_candidates = Candidate::MAX_CANDIDATES
    @vote = Vote.new
  end


  def create
    if current_user.blank?
      return redirect_to new_session_url, notice: "Please Sign In to Vote!"
    end

    @vote = Vote.new(vote_params.merge(user: current_user))
    if @vote.save
      redirect_to vote_url(@vote), notice: "Your vote has been successfully recorded."
    else
      @candidates = Candidate.all
      @write_in_candidate = Candidate.new
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # the two redirects here protect the system from tampering.
    # The vote id is exposed in the url. In a production scenario we would want to use UUIDS.
    # Even with UUIDS the browser history could give access to previously visited vote#show pages.
    # If the current user doesn't match the requested vote, we will send them back to login!
    if current_user.blank?
      return redirect_to root_url
    end

    if @vote = Vote.find_by(id: params[:id], user_id: current_user.id)
      render :show
    else
      redirect_to root_url
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:candidate_id)
  end
end
