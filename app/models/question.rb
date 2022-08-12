class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :award, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation

  scope :created_or_updated_today, lambda { where(updated_at: Time.current.all_day) }

  def mark_best_answer(answer)
    # self.update(best_answer_id: answer.id)
    update(best_answer_id: answer.id)
    self.award.update(user: answer.user) if award.present?
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
