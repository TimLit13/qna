class NewAnswerNotificationMailer < ApplicationMailer
  def send_question_with_new_answer(user, answer)
    @answer = answer

    mail to: user.email, subject: "New answer added for question: #{@answer.question.title}"
  end
end
