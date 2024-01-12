class CandidatesController < ApplicationController
  def create
    if current_user.blank?
      redirect_to new_session_url
      return
    end

    if current_user_has_voted?
      redirect_to votes_url, notice: "You have already voted. Thanks for your participation!"
      return
    end

    @write_in_candidate = Candidate.new(candidate_params)

    if @write_in_candidate.save
      @vote = Vote.new(candidate: @write_in_candidate, user: current_user)
      if @vote.save
        redirect_to vote_url(@vote), notice: "Your vote has been successfully recorded."
      else
        @candidates = Candidate.all
        render 'votes/new', status: :unprocessable_entity
      end
    else
      @candidates = Candidate.all
      @vote = Vote.new
      render 'votes/new', status: :unprocessable_entity
    end
  end

  private

  def candidate_params
    params.require(:candidate).permit(:name)
  end
end
