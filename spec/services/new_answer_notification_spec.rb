require 'rails_helper'

RSpec.describe NewAnswerNotification do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user_id: user.id) }
  let(:other_user) { create(:user) }

  context 'new answer created' do
    let!(:answers) { create_list(:answer, 3, user_id: user.id, question_id: question.id) }

    it 'sends new answers notifications for question author' do
      answers.each do |answer|
        expect(NewAnswerNotificationMailer).to receive(:send_question_with_new_answer).with(user, answer).and_call_original

        subject.send_question_with_new_answer(answer)
      end
    end
  end
end
