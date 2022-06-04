class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user

  validates :title, :body, presence: true

  def mark_best_answer(answer)
    # self.update(best_answer_id: answer.id)
    update(best_answer_id: answer.id)
  end
end
