require 'rails_helper'

shared_examples_for 'API Authorizable' do
  it 'returns 401 status if the is no access_token' do
    do_request(method, api_path, headers: headers)

    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns 401 if access_token is invalid' do
    do_request(method, api_path, params: { access_token: 'smth' }.to_json, headers: headers)

    expect(response).to have_http_status(:unauthorized)
  end
end
