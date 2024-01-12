class User < ApplicationRecord
  has_one :vote

  validates_uniqueness_of :email
  validates :email, email: true
  validates :zipcode, format: { with: /\A\d*5\z/, message: "must be 5 digits" }, allow_blank: true

  def has_voted?
    vote.present?
  end
end
