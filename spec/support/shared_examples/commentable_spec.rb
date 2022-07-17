require 'rails_helper'

shared_examples_for 'commentable' do
  context 'associations' do
    it { should have_many(:comments).dependent(:destroy) }
  end
end
