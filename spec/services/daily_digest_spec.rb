require 'rails_helper'

RSpec.describe DailyDigest do
  let(:users) { create_list(:user, 3) }

  context 'questions created' do
    let!(:questions) { create_list(:question, 3, user_id: users.first.id) }

    it 'sends daily digest to all users' do
      users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, questions).and_call_original }

      subject.send_digest
    end
  end

  context 'questions was not created' do
    it 'does not send daily digest to all users' do
      expect(DailyDigestMailer).to_not receive(:digest)

      subject.send_digest
    end
  end
end
