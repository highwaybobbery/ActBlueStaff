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
    @vote = Vote.new
  end


  def create
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
    @vote = Vote.find(params[:id])
    render :show
  end

  private

  def vote_params
    params.require(:vote).permit(:candidate_id)
  end
end
