class RecountVotesJob < ApplicationJob
  queue_as :default

  def perform()
    t = Time.now
    Rails.logger.info("recount executing")
    Rails.cache.write(Vote::VOTES_BY_CANDIDATE_CACHE_KEY, Vote.votes_by_candidate)
    Rails.logger.info("recount complete time_elapsed=#{Time.now - t}")
  end
end
