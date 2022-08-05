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

      it_behaves_like 'Successfull response'

      it_behaves_like 'Returns list of resources' do
        let(:resources) { answers }
        let(:resources_response) { json['answers'] }
      end

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id body created_at updated_at] }
        let(:resource) { answers.first }
        let(:resource_response) { json['answers'].first }
      end

      it 'contains user object' do
        expect(json['answers'].first['user']['id']).to eq(answers.first.user.id)
      end

      it 'contains short body' do
        expect(json['answers'].first['short_body']).to eq(answers.first.body.truncate(7))
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, :with_files, user: user, question: question) }
    let!(:comments) { create_list(:comment, 3, user: user, commentable: answer) }
    let!(:links) { create_list(:link, 3, :google, linkable: answer) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable' do
        let(:method) { :get }
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        get api_path, params: { access_token: access_token.token, question_id: question.id, id: answer.id },
                      headers: headers
      end

      it_behaves_like 'Successfull response'

      it 'returns requested answer' do
        expect(json['answer']['id']).to eq(answer.id)
      end

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id body created_at updated_at] }
        let(:resource) { answer }
        let(:resource_response) { json['answer'] }
      end

      it 'contains user object' do
        expect(json['answer']['user']['id']).to eq(answer.user.id)
      end

      it 'contains short body' do
        expect(json['answer']['short_body']).to eq(answer.body.truncate(7))
      end

      describe 'comments' do
        let(:comment) { comments.first }

        it_behaves_like 'Returns list of resources' do
          let(:resources) { comments }
          let(:resources_response) { json['answer']['comments'] }
        end

        it_behaves_like 'Public fields' do
          let(:attributes) { %w[id body created_at updated_at] }
          let(:resource) { comment }
          let(:resource_response) { json['answer']['comments'].first }
        end
      end

      describe 'links' do
        let(:link) { links.first }

        it 'returns list of links' do
          expect(json['answer']['links'].count).to eq(links.count)
        end

        it_behaves_like 'Public fields' do
          let(:attributes) { %w[name url] }
          let(:resource) { link }
          let(:resource_response) { json['answer']['links'].first }
        end
      end

      describe 'files' do
        let(:file) { answer.files.first }

        it_behaves_like 'Returns list of resources' do
          let(:resources) { answer.files }
          let(:resources_response) { json['answer']['files'] }
        end

        it 'returns url of file' do
          expect(json['answer']['files'].first['url']).to include(file.blob.filename.to_s)
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable' do
        let(:method) { :post }
        let(:path) { api_path }
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it_behaves_like 'Successfull response' do
        before do
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) }.to_json,
                         headers: headers
        end
      end

      context 'invalid attributes' do
        before do
          post api_path,
               params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }.to_json, headers: headers
        end

        it 'does not save new answer in db' do
          expect(Answer.count).to eq(0)
        end

        it 'returns 422 status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'valid attributes' do
        let(:attributes_for_answer) { attributes_for(:answer) }

        before do
          post api_path, params: { access_token: access_token.token, answer: attributes_for_answer }.to_json,
                         headers: headers
        end

        it 'saves new answer in db' do
          expect(Answer.count).to eq(1)
        end

        it_behaves_like 'Successfull response'

        it_behaves_like 'Public fields' do
          let(:attributes) { %w[id body created_at updated_at] }
          let(:resource) { Answer.first }
          let(:resource_response) { json['answer'] }
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:question_id/answers/id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }
    let!(:comments) { create_list(:comment, 3, user: user, commentable: answer) }
    let!(:links) { create_list(:link, 3, :google, linkable: answer) }
    let!(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable' do
        let(:method) { :patch }
        let(:path) { api_path }
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it_behaves_like 'Successfull response' do
        before do
          patch api_path, params: { access_token: access_token.token, answer: { body: 'Updated body' } }.to_json,
                          headers: headers
        end
      end

      context 'invalid attributes' do
        before do
          patch api_path,
                params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }.to_json, headers: headers
        end

        it 'does not update answer in db' do
          answer.reload

          expect(answer.body).to_not eq(nil)
        end

        it 'returns 422 status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'valid attributes' do
        before do
          patch api_path, params: { access_token: access_token.token, answer: { body: 'Updated body' } }.to_json,
                          headers: headers
        end

        context 'author of answer' do
          it 'updates answer in db' do
            answer.reload

            expect(answer.body).to eq('Updated body')
          end

          it_behaves_like 'Successfull response'

          it_behaves_like 'Public fields' do
            let(:attributes) { %w[id body created_at updated_at] }
            let(:resource) { Answer.first }
            let(:resource_response) { json['answer'] }
          end
        end

        context 'user is not author of question' do
          let(:not_author_user) { create(:user) }
          let(:other_answer) { create(:answer, question: question, user: not_author_user) }
          let!(:other_api_path) { "/api/v1/questions/#{question.id}/answers/#{other_answer.id}" }

          it 'does not update answer in db' do
            patch other_api_path, params: { access_token: access_token.token, answer: { body: 'Updated body' } }.to_json,
                                  headers: headers

            other_answer.reload

            expect(other_answer.body).to_not eq('Updated body')
          end
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:question_id/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }
    let!(:comments) { create_list(:comment, 3, user: user, commentable: answer) }
    let!(:links) { create_list(:link, 3, :google, linkable: question) }
    let!(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable' do
        let(:method) { :delete }
        let(:path) { api_path }
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        delete api_path, params: { access_token: access_token.token, question_id: question.id, id: answer.id }.to_json,
                         headers: headers
      end

      context 'author of question' do
        it_behaves_like 'Successfull response'

        it 'deletes answer from db' do
          expect(Answer.count).to eq(0)
        end
      end

      context 'user is not author of question' do
        let(:not_author_user) { create(:user) }
        let(:other_answer) { create(:answer, question: question, user: not_author_user) }
        let!(:other_api_path) { "/api/v1/questions/#{question.id}/answers/#{other_answer.id}" }

        it 'does not delete answer from db' do
          expect do
            delete other_api_path, params: { access_token: access_token.token }.to_json, headers: headers
          end.to_not change(Answer, :count)
        end
      end
    end
  end
end
