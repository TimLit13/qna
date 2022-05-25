require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe '.author_of?' do
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
end
