class NewAnswerNotification
  def send_question_with_new_answer(answer)
    answer.question.subscriptions.find_each do |subscription|
      NewAnswerNotificationMailer.send_question_with_new_answer(subscription.user, answer).deliver_later
    end
  end
end
