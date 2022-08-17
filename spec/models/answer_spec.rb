require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should have_many(:links).dependent(:destroy) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  describe 'attachments' do
    it 'have many attached file' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for :links }
  end

  describe 'shared examples' do
    it_behaves_like 'votable' do
      let(:user) { create(:user) }
      let!(:question) { create(:question, user: user) }
      let!(:resource) { create(:answer, question: question, user: user) }
    end

    it_behaves_like 'commentable'
  end

  describe '#send_notification_with_new_answer' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    it 'enqueue job after answer created' do
      ActiveJob::Base.queue_adapter = :test

      answer = described_class.create!(user_id: user.id, question_id: question.id, body: 'NewAnswer')

      expect do
        answer.send(:send_notification_with_new_answer)
      end.to have_enqueued_job(NewAnswerForQuestionJob).on_queue('default')
    end
  end
end
