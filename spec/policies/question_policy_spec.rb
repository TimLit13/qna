require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:question) { create(:question, user: author) }

  subject { described_class }

  permissions :create? do
    it 'grants access if user is signed in' do
      expect(subject).to permit(user, Question)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, Question)
    end

    it 'denies access if user is not signed in' do
      expect(subject).to_not permit(nil, Question)
    end
  end

  permissions :update? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, question)
    end

    it 'grants access if user is author of answer' do
      expect(subject).to permit(author, question)
    end

    it 'denies access if user is not author' do
      expect(subject).to_not permit(user, question)
    end
  end

  permissions :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, question)
    end

    it 'grants access if user is author of answer' do
      expect(subject).to permit(author, question)
    end

    it 'denies access if user is not author' do
      expect(subject).to_not permit(user, question)
    end
  end

  # permissions :rate_up? do
  #   it 'grants access if user is admin' do
  #     expect(subject).to permit(admin, question)
  #   end

  #   it 'denies access if user is author of answer' do
  #     expect(subject).to_not permit(author, question)
  #   end

  #   it 'grants access if user is not author' do
  #     expect(subject).to permit(user, question)
  #   end
  # end

  # permissions :rate_down? do
  #   it 'grants access if user is admin' do
  #     expect(subject).to permit(admin, question)
  #   end

  #   it 'denies access if user is author of answer' do
  #     expect(subject).to_not permit(author, question)
  #   end

  #   it 'grants access if user is not author' do
  #     expect(subject).to permit(user, question)
  #   end
  # end

  # permissions :cancel_rate? do
  #   it 'grants access if user is admin' do
  #     expect(subject).to permit(admin, question)
  #   end

  #   it 'denies access if user is author of answer' do
  #     expect(subject).to_not permit(author, question)
  #   end

  #   it 'grants access if user is not author' do
  #     expect(subject).to permit(user, question)
  #   end
  # end
end
