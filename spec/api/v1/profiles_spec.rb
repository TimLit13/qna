require 'rails_helper'

RSpec.describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'unauthorized' do
      it 'returns 401 status if the is no access_token' do
        get '/api/v1/profiles/me', headers: headers
        # expect(response.status).to eq(401)
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns 401 if access_token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: 'smth' }, headers: headers
        # expect(response.status).to eq(401)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 20x status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq(user.send(attr).as_json)
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
end
