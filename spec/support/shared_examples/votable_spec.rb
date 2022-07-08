require 'rails_helper'

shared_examples_for 'votable' do
  context 'associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  context 'public methods' do
    let(:second_user) { create(:user) }
    
    context 'not rated yet' do
      it '#rate_up' do
        resource.rate_up(user)
        expect(resource.votes.where(user: user).last.rating).to eq(1)
      end

      it '#rate_down' do
        resource.rate_down(user)
        expect(resource.votes.where(user: user).last.rating).to eq(-1)
      end

      it '#rated_before?' do
        expect(resource.votes.where(user: user).any?).to be_falsy
      end

      it '#total_rating' do
        expect(resource.votes.sum(:rating)).to eq(0)
      end
    end

    context 'rated before' do
      before { resource.rate_up(user) }

      it '#rate_up' do
        resource.rate_up(user)
        expect(resource.votes.where(user: user).last.rating).to eq(1)
      end

      it '#rate_down' do
        resource.rate_down(user)
        expect(resource.votes.where(user: user).last.rating).to eq(1)
      end

      it '#cancel_rate' do
        resource.cancel_rate(user)
        expect(resource.votes.where(user: user).any?).to be_falsy
      end

      it '#rated_before?' do
        expect(resource.votes.where(user: user).any?).to be_truthy
      end

      it '#total_rating' do
        resource.rate_up(second_user)
        expect(resource.votes.sum(:rating)).to eq(2)
      end
    end
  end
end
