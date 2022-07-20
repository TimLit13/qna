class CommentsChannel < ApplicationCable::Channel
  def subscribed
    logger.debug 'Subscribed to comments channel'
    stream_from "question/#{params[:question_id]}/comments"
  end

  def unsubscribed
    logger.debug 'Unsubscribed from comments channel'
  end
end
