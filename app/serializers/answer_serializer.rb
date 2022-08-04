class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :short_body

  has_many :comments
  has_many :links, as: :linkable
  has_many :files, serializer: FileSerializer
  belongs_to :user
  belongs_to :question

  def short_body
    object.body.truncate(7)
  end
end
