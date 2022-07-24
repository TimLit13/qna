require 'rails_helper'

RSpec.describe Users::OauthEmailConfirmationsController, type: :controller do
  describe 'GET #new' do
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'user already registrated' do
      let!(:user) { create(:user) }

      it 'does not create new user in db' do
        expect { post :create, params: { email: user.email } }.to_not change(User, :count)
      end

      it 'redirects to root path' do
        post :create, params: { email: user.email }
        expect(response).to redirect_to root_path
      end
    end

    context 'user is not registrated' do
      it 'create new user in db' do
        expect { post :create, params: { email: 'test@test.com' } }.to change(User, :count).by(1)
      end

      it 'redirects to root path' do
        post :create, params: { email: 'test@test.com' }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user typed invalid email' do
      it 'renders new view' do
        post :create, params: { email: nil }
        expect(response).to render_template :new
      end
    end
  end
end
