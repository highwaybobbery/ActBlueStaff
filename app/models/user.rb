class User < ApplicationRecord
  has_one :vote

  normalizes :zipcode, with: ->(value) { value.to_s.rjust(5, '0') }
  normalizes :email, with: ->(value) { value.strip.downcase }

  validates_uniqueness_of :email
  validates :email, email: true
  validates :zipcode, format: { with: /\A\d{5}\z/, message: "must be 5 digits" }, allow_blank: true

  def has_voted?
    vote.present?
  end
end
