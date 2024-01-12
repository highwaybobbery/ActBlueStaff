class Vote < ApplicationRecord
  belongs_to :candidate
  belongs_to :user

  validates_uniqueness_of :user
end
