class Candidate < ApplicationRecord
  has_many :votes

  MAX_CANDIDATES = 10

  validates_uniqueness_of :name
  validates_presence_of :name
  validate :validate_candidate_count, on: :create

  def validate_candidate_count
    self.errors.add(:base, "exceeded maximum entries") if Candidate.count > MAX_CANDIDATES - 1
  end
end
