require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe '#author_of?' do
    context 'user is author of any resource' do
      let(:first_user) { create(:user) }
      let(:question) { create(:question, user: first_user) }
      let(:second_user) { create(:user) }

      it 'user is an author of resource' do
        expect(first_user.author_of?(question)).to be_truthy
      end

      it 'user is not an author of resource' do
        expect(second_user.author_of?(question)).to be_falsy
      end
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOath') }

    it 'calls FindForOath service' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
