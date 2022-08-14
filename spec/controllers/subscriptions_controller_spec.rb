require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:author) { create(:user) }
  let(:not_author) { create(:user) }
  let!(:question) { create(:question, user: author) }

  describe 'POST #create' do
    let(:make_request_for_create) { post :create, params: { question_id: question.id }, format: :js }

    context 'authenicated user' do
      context 'author' do
        before { login(author) }

        it 'saves new subscription in db' do
          expect { make_request_for_create }.to change(Subscription, :count).by(1)
        end

        it 'assigns question for subscription' do
          make_request_for_create

          expect(assigns(:subscription).question).to eq(question)
        end

        it 'assigns user for subscription' do
          make_request_for_create

          expect(assigns(:subscription).user).to eq(author)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not save new subscription in db' do
        expect { make_request_for_create }.to_not change(Subscription, :count)
      end
    end
  end
end
