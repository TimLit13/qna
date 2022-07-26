require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question_for_answer) { create(:question, user_id: user.id) }

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :update, create(:question, user_id: user.id), user_id: user.id }
    it { should_not be_able_to :update, create(:question, user_id: other.id), user_id: user.id }

    it { should be_able_to :update, create(:answer, user_id: user.id, question: question_for_answer), user_id: user.id }
    it {
      should_not be_able_to :update, create(:answer, user_id: other.id, question: question_for_answer), user_id: user.id
    }

    #   it { should be_able_to :update, create(:comment, user: user), user_id: user.id }
    #   it { should_not be_able_to :update, create(:comment, user: other), user_id: user.id }
  end
end
