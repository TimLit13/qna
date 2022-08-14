class NewAnswerForQuestionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerNotification.new.send_question_with_new_answer(answer)
  end
end
