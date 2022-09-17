class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user
  has_many :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  after_create :send_notification_with_new_answer

  private

  def send_notification_with_new_answer
    NewAnswerForQuestionJob.perform_later(self)
  end
end
