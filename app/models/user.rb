class User < ApplicationRecord
  has_one :vote

  validates_uniqueness_of :email
  validates :email, email: true

  def has_voted?
    vote.present?
  end
end
