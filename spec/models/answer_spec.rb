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
    # it_behaves_like 'votable'
  end
end
