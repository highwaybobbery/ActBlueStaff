class Candidate < ApplicationRecord
  has_many :votes

  validates_uniqueness_of :name
  validates_presence_of :name
end
