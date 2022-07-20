class AnswersChannel < ApplicationCable::Channel
  def subscribed
    logger.debug 'Subscribed to answers channel for question'
    stream_from "question/#{params[:question_id]}/answers"
  end

  def unsubscribed
    logger.debug 'Unsubscribed from answers channel from question'
  end
end
