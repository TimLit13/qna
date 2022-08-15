require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:author) { create(:user) }
  let!(:not_author) { create(:user) }
  let!(:admin) { create(:user, admin: true) }
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

        it 'renders template create' do
          make_request_for_create

          expect(response).to render_template :create
        end

        it 'Successfull response' do
          make_request_for_create

          expect(response).to be_successful
        end
      end

      context 'admin' do
        before { login(admin) }

        it 'saves new subscription in db' do
          expect { make_request_for_create }.to change(Subscription, :count).by(1)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not save new subscription in db' do
        expect { make_request_for_create }.to_not change(Subscription, :count)
      end

      it 'Unsuccessfull response' do
        make_request_for_create

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, question_id: question.id, user_id: author.id) }
    let(:make_request_for_destroy) do
      delete :destroy, params: { question_id: question.id, id: subscription.id }, format: :js
    end

    context 'authenicated user' do
      context 'author' do
        before { login(author) }

        it 'deletes the subscription from db' do
          expect { make_request_for_destroy }.to change(Subscription, :count).by(-1)
        end

        it 'assigns question for subscription' do
          make_request_for_destroy

          expect(assigns(:subscription).question).to eq(question)
        end

        it 'assigns user for subscription' do
          make_request_for_destroy

          expect(assigns(:subscription).user).to eq(author)
        end

        it 'renders template destroy' do
          make_request_for_destroy

          expect(response).to render_template :destroy
        end

        it 'Successfull response' do
          make_request_for_destroy

          expect(response).to be_successful
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not delete the subscription from db' do
        expect { make_request_for_destroy }.to_not change(Subscription, :count)
      end

      it 'Unsuccessfull response' do
        make_request_for_destroy

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
