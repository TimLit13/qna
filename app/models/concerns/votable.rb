module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rate_up(user)
    votes.create(user: user, rating: 1) unless rated_before?(user)
  end

  def rate_down(user)
    votes.create(user: user, rating: -1) unless rated_before?(user)
  end

  def cancel_rate(user)
    votes.where(user: user).destroy_all if rated_before?(user)
  end

  def rated_before?(user)
    votes.where(user: user).any?
  end

  def total_rating
    votes.sum(:rating)
  end
end
