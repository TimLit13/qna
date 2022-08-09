require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_one(:award).dependent(:destroy) }
    it { should belong_to(:best_answer).class_name('Answer').optional }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe 'attachments' do
    it 'have many attached file' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for :links }
  end

  describe 'shared examples' do
    it_behaves_like 'votable' do
      let(:user) { create(:user) }
      let!(:resource) { create(:question, user: user) }
    end

    it_behaves_like 'commentable'
  end

  describe 'reputation' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user_id: user.id) }

    it 'calls ReputationJob#perform_later' do
      expect(ReputationJob).to receive(:perform_later).with(question)

      question.save!
    end
  end
end
