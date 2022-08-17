require 'rails_helper'

RSpec.describe NewAnswerNotificationMailer, type: :mailer do
  describe '#send_question_with_new_answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user_id: user.id) }
    let!(:answers_created_before) { create_list(:answer, 2, user_id: user.id, question_id: question.id) }
    let!(:new_answer) { create(:answer, user_id: user.id, question_id: question.id) }
    let!(:mail) { NewAnswerNotificationMailer.send_question_with_new_answer(user, new_answer) }

    context 'headers' do
      it 'renders subject' do
        expect(mail.subject).to match('New answer added')
        expect(mail.subject).to match(question.title)
      end

      it 'mails to users email' do
        expect(mail.to).to include(user.email)
      end
    end

    context 'body' do
      it 'renders question title and body' do
        expect(mail.body.encoded).to match(question.title)
        expect(mail.body.encoded).to match(question.body)
      end

      it 'renders new answer' do
        expect(mail.body.encoded).to match(new_answer.body)
      end

      it 'renders answers' do
        answers_created_before.each { |answer| expect(mail.body.encoded).to match(answer.body) }
      end
    end
  end
end
