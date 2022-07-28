require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'guest abilities' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'admin abilities' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'user abilities' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user_id: user.id) }
    let(:other_user_question) { create(:question, user_id: other_user.id) }
    let(:answer) { create(:answer, question: question, user_id: user.id) }
    let(:other_user_answer) { create(:answer, question: question, user_id: other_user.id) }

    context 'common' do
      it { should_not be_able_to :manage, :all }

      it { should be_able_to :read, :all }
    end

    context 'for questions' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, question, user_id: user.id }
      it { should_not be_able_to :update, other_user_question, user_id: user.id }

      it { should be_able_to :destroy, question, user_id: user.id }
      it { should_not be_able_to :destroy, other_user_question, user_id: user.id }

      it { should be_able_to %i[rate_up rate_down cancel_rate], other_user_question, user_id: user.id }
      it {
        should_not be_able_to %i[rate_up rate_down cancel_rate], create(:question, user_id: user.id), user_id: user.id
      }
    end

    context 'for answers' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, answer, user_id: user.id }
      it {
        should_not be_able_to :update, other_user_answer, user_id: user.id
      }

      it { should be_able_to :destroy, answer, user_id: user.id }
      it {
        should_not be_able_to :destroy, other_user_answer, user_id: user.id
      }

      it { should be_able_to %i[rate_up rate_down cancel_rate], other_user_answer, user_id: user.id }
      it { should_not be_able_to %i[rate_up rate_down cancel_rate], answer, user_id: user.id }

      it { should be_able_to :mark_answer_as_best, other_user_answer, user_id: user.id }
    end

    context 'for comments' do
      it { should be_able_to :create, Comment }
    end

    context 'for links' do
      it { should be_able_to :destroy, create(:link, :google, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, :google, linkable: other_user_question) }
    end

    context 'for attachments' do
      let(:question_with_files) { create(:question, :with_files, user: user) }
      let(:other_user_question_with_files) { create(:question, :with_files, user: other_user) }

      it { should be_able_to :destroy, question_with_files.files.first }
      it { should_not be_able_to :destroy, other_user_question_with_files.files.first }
    end
  end
end
