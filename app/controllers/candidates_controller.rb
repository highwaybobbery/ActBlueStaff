class CandidatesController < ApplicationController
  def create
    if current_user.blank?
      redirect_to new_user_url
    end

    if current_user.has_voted?
      redirect_to votes_url, notice: "You have already voted. Thanks for your participation!"
    end

    @candidate = Candidate.new(candidate_params)

    respond_to do |format|
      if @candidate.save
        Vote.create(candidate: @candidate, user: current_user)
        format.html { redirect_to votes_url, notice: "Your vote has been successfully recorded. Thanks for your participation!" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def candidate_params
      params.require(:candidate).permit(:name)
    end
end
