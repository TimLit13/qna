require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe '#digest' do
    let!(:user) { create(:user) }
    let!(:questions) { create_list(:question, 3, user_id: user.id) }
    let!(:mail) { DailyDigestMailer.digest(user, Question.created_or_updated_today) }

    context 'headers' do
      it 'renders subject' do
        expect(mail.subject).to eq('Digest')
      end

      it 'mails to users email' do
        expect(mail.to).to include(user.email)
      end
    end

    context 'body' do
      it 'renders questions title' do
        questions.each { |question| expect(mail.body.encoded).to match(question.title) }
      end
    end
  end
end
