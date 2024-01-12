class Vote < ApplicationRecord
  belongs_to :candidate
  belongs_to :user

  validates_uniqueness_of :user

  after_create :recount_votes

  # NOTE: In production it would be best to store this value in a settings table in db,
  # so that this can be tuned to respond to high load events.
  VOTE_COUNT_UPDATE_THRESHOLD = 10
  VOTES_BY_CANDIDATE_CACHE_KEY = 'votes_by_candidate'

  def self.cached_votes_by_candidate
    # NOTE: By default caching is disabled in development.
    # Enable/disable it with `rails dev:cache`

    if Rails.configuration.cache_store == :null_store
      Rails.logger.info "caching disabled, reading live vote counts"
      votes_by_candidate
    else
      Rails.logger.info "reading cached votes by candidate"
      Rails.cache.read(VOTES_BY_CANDIDATE_CACHE_KEY) || {}
    end
  end


  # This method should not be used directly in production. Use the cached version above.
  # This method is used by the RecountVotesJob to get the new results to put in cache periodically.
  def self.votes_by_candidate
    joins(:candidate).group('candidates.name').order('count_all desc').count
  end

  private

  def recount_votes
    # we will recalculate the votes when the latest vote's id is evenly divisible by the update threshold

    # in production we would be using uuids, so keeping a counter in Redis would probably be better.
    # That being said, using atomic operations to update the tally directly in redis would probably obviate the need
    # for this delay at all.
    if id % VOTE_COUNT_UPDATE_THRESHOLD == 0
      Rails.logger.info "recount job enqueued"
      RecountVotesJob.perform_later
    else
      Rails.logger.info "recount job skipped"
    end
  end
end
