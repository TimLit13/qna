require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:question) { create(:question, user: author) }

  subject { described_class }

  permissions :create? do
    it 'grants access if user is signed in' do
      expect(subject).to permit(user, Comment)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, Comment)
    end

    it 'denies access if user is not signed in' do
      expect(subject).to_not permit(nil, Comment)
    end
  end
end
