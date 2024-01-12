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
      Vote.create!(candidate: @write_in_candidate, user: current_user)
      redirect_to votes_url, notice: "Your vote has been successfully recorded. Thanks for your participation!"
    else
      @candidates = Candidate.all
      @vote = Vote.new
      render 'votes/new', status: :unprocessable_entity
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def candidate_params
      params.require(:candidate).permit(:name)
    end
end
