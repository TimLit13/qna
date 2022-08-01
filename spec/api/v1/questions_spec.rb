require 'rails_helper'

RSpec.describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    context 'unauthorized' do
      it 'returns 401 status if the is no access_token' do
        get '/api/v1/questions', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns 401 if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: 'smth' }, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, user: user, question: question) }

      before do
        get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 20x status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq(2)
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq(question.send(attr).as_json)
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq(question.user.id)
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq(question.title.truncate(7))
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq(3)
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq(answer.send(attr).as_json)
          end
        end
      end
    end
  end
end
