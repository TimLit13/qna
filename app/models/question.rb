class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :award, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  def mark_best_answer(answer)
    # self.update(best_answer_id: answer.id)
    update(best_answer_id: answer.id)
    self.award.update(user: answer.user) if award.present?
  end
end
