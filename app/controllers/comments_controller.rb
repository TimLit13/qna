class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable

  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    @commentable = if params[:question_id]
                     Question.find(params[:question_id])
                   else
                     Answer.find(params[:answer_id])
                   end
  end

  def publish_comment
    return if @comment.errors.any?

    question_id = if @commentable.instance_of?(Question)
                    @commentable.id
                  else
                    @commentable.question.id
                  end

    ActionCable.server.broadcast(
      "question/#{question_id}/comments",
      hash_for_broadcast
    )
  end

  def hash_for_broadcast
    {
      comment: @comment,
      type: @comment.commentable_type.downcase,
      type_id: @commentable.id,
      author: @comment.user
    }
  end
end
