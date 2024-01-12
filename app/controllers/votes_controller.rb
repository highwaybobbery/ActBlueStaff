class VotesController < ApplicationController
  before_action :set_vote, only: %i[ show edit update destroy ]

  # GET /votes or /votes.json
  def index
    @votes = Vote.joins(:candidate).group('candidates.name').order('count_all desc').count
  end

  # GET /votes/new
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


  # POST /votes or /votes.json
  def create
    @vote = Vote.new(vote_params.merge(user_id: current_user.id))
    if @vote.save
      redirect_to votes_url, notice: "Your vote has been successfully recorded. Thanks for your participation!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def vote_params
      params.require(:vote).permit(:candidate_id)
    end
end
