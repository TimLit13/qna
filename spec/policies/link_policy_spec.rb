require 'rails_helper'

RSpec.describe LinkPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:question) { create(:question, user: author) }
  let(:link) { create(:link, :google, linkable: question) }

  subject { described_class }

  permissions :destroy? do
    it 'grants access if user is signed in' do
      expect(subject).to permit(author, link)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, link)
    end

    it 'denies access if user is not signed in' do
      expect(subject).to_not permit(nil, link)
    end

    it 'denies access if user is not author' do
      expect(subject).to_not permit(user, link)
    end
  end
end
