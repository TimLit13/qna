require 'rails_helper'

RSpec.describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable' do
        let(:method) { :get }
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question, user: user) }
      let!(:answers) { create_list(:answer, 3, user: user, question: question) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 20x status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq(answers.count)
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answers'].first[attr]).to eq(answers.first.send(attr).as_json)
        end
      end

      it 'contains user object' do
        expect(json['answers'].first['user']['id']).to eq(answers.first.user.id)
      end

      it 'contains short body' do
        expect(json['answers'].first['short_body']).to eq(answers.first.body.truncate(7))
      end
    end
  end
end
