require 'rails_helper'

RSpec.describe SubscriptionPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:question) { create(:question, user_id: author.id) }
  let(:subscription) { create(:subscription, question_id: question.id, user_id: author.id) }

  subject { described_class }

  permissions :create? do
    it 'grants access if user is signed in' do
      expect(subject).to permit(user, Subscription)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, Subscription)
    end

    it 'denies access if user is not signed in' do
      expect(subject).to_not permit(nil, Subscription)
    end
  end

  permissions :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, subscription)
    end

    it 'grants access if user is author of subscription' do
      expect(subject).to permit(author, subscription)
    end

    it 'denies access if user is not author' do
      expect(subject).to_not permit(user, subscription)
    end
  end
end
