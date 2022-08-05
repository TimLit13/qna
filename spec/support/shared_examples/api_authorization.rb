require 'rails_helper'

shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if the is no access_token' do
      do_request(method, api_path, headers: headers)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 if access_token is invalid' do
      do_request(method, api_path, params: { access_token: 'smth' }.to_json, headers: headers)

      expect(response).to have_http_status(:unauthorized)
    end
  end
end

shared_examples_for 'Successfull response' do
  it 'returns 20x status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'Public fields' do
  it 'returns all public fields' do
    attributes.each do |attr|
      expect(resource_response[attr]).to eq(resource.send(attr).as_json)
    end
  end
end

shared_examples_for 'Private fields' do
  it 'does not return private fields' do
    attributes.each do |attr|
      expect(resource_response).to_not have_key(attr)
    end
  end
end

shared_examples_for 'Returns list of resources' do
  it 'returns list of resources' do
    expect(resources_response.size).to eq(resources.count)
  end
end
