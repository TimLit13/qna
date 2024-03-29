require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
  describe 'Github' do
    let(:oauth_data) { mock_auth_hash('Github') }
    before { @request.env['omniauth.auth'] = oauth_data }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq(user)
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exists' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path if user does not exists' do
        expect(response).to redirect_to root_path
      end

      it 'does not login if not exists' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Vkontakte' do
    let(:oauth_data) { mock_auth_hash('Vkontakte') }
    before { @request.env['omniauth.auth'] = oauth_data }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :vkontakte
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :vkontakte
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq(user)
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exists' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :vkontakte
      end

      it 'redirects to root path if user does not exists' do
        expect(response).to redirect_to root_path
      end

      it 'does not login if not exists' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Yandex' do
    let(:oauth_data) { mock_auth_hash('Yandex') }
    before { @request.env['omniauth.auth'] = oauth_data }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :yandex
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :yandex
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq(user)
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exists' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :yandex
      end

      it 'redirects to root path if user does not exists' do
        expect(response).to redirect_to root_path
      end

      it 'does not login if not exists' do
        expect(subject.current_user).to_not be
      end
    end
  end
end
