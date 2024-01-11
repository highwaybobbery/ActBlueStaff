class User < ApplicationRecord
  has_one :vote

  def has_voted?
    vote.present?
  end
end
