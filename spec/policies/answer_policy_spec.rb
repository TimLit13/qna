require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, question: question, user: author) }

  subject { described_class }

  permissions :create? do
    it 'grants access if user is signed in' do
      expect(subject).to permit(user, Answer)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, Answer)
    end

    it 'denies access if user is not signed in' do
      expect(subject).to_not permit(nil, Answer)
    end
  end

  permissions :update? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, answer)
    end

    it 'grants access if user is author of answer' do
      expect(subject).to permit(author, answer)
    end

    it 'denies access if user is not author' do
      expect(subject).to_not permit(user, answer)
    end
  end

  permissions :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, answer)
    end

    it 'grants access if user is author of answer' do
      expect(subject).to permit(author, answer)
    end

    it 'denies access if user is not author' do
      expect(subject).to_not permit(user, answer)
    end
  end

  permissions :mark_answer_as_best? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, answer)
    end

    it 'grants access if user is author of answer' do
      expect(subject).to permit(author, answer)
    end

    it 'denies access if user is not author' do
      expect(subject).to_not permit(user, answer)
    end
  end

  # permissions :rate_up? do
  #   it 'grants access if user is admin' do
  #     expect(subject).to permit(admin, answer)
  #   end

  #   it 'denies access if user is author of answer' do
  #     expect(subject).to_not permit(author, answer)
  #   end

  #   it 'grants access if user is not author' do
  #     expect(subject).to permit(user, answer)
  #   end
  # end

  # permissions :rate_down? do
  #   it 'grants access if user is admin' do
  #     expect(subject).to permit(admin, answer)
  #   end

  #   it 'denies access if user is author of answer' do
  #     expect(subject).to_not permit(author, answer)
  #   end

  #   it 'grants access if user is not author' do
  #     expect(subject).to permit(user, answer)
  #   end
  # end

  # permissions :cancel_rate? do
  #   it 'grants access if user is admin' do
  #     expect(subject).to permit(admin, answer)
  #   end

  #   it 'denies access if user is author of answer' do
  #     expect(subject).to_not permit(author, answer)
  #   end

  #   it 'grants access if user is not author' do
  #     expect(subject).to permit(user, answer)
  #   end
  # end
end
