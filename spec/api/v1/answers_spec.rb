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

      it 'returns 20x status' do
        expect(response).to be_successful
      end

      it 'returns requested answer' do
        expect(json['answer']['id']).to eq(answer.id)
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq(answer.send(attr).as_json)
        end
      end

      it 'contains user object' do
        expect(json['answer']['user']['id']).to eq(answer.user.id)
      end

      it 'contains short body' do
        expect(json['answer']['short_body']).to eq(answer.body.truncate(7))
      end

      describe 'comments' do
        let(:comment) { comments.first }

        it 'returns list of answers' do
          expect(json['answer']['comments'].count).to eq(comments.count)
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(json['answer']['comments'].first[attr]).to eq(comment.send(attr).as_json)
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }

        it 'returns list of links' do
          expect(json['answer']['links'].count).to eq(links.count)
        end

        it 'returns all public fields' do
          %w[name url].each do |attr|
            expect(json['answer']['links'].first[attr]).to eq(link.send(attr).as_json)
          end
        end
      end

      describe 'files' do
        let(:file) { answer.files.first }

        it 'returns list of files' do
          expect(json['answer']['files'].count).to eq(answer.files.count)
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

      it 'returns 20x status' do
        post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) }.to_json,
                       headers: headers
        puts response.status
        expect(response).to be_successful
      end

      context 'invalid attributes' do
        it 'does not save new answer in db' do
          expect do
            post api_path,
                 params: { access_token: access_token.token,
                           answer: attributes_for(:answer, :invalid) }.to_json,
                 headers: headers
          end.to_not change(Answer, :count)
        end

        it 'returns 422 status' do
          post api_path,
               params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }.to_json, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'valid attributes' do
        let(:attributes_for_answer) { attributes_for(:answer) }

        it 'saves new answer in db' do
          expect  do
            post api_path,
                 params: { access_token: access_token.token,
                           answer: attributes_for_answer }.to_json,
                 headers: headers
          end.to change(Answer, :count).by(1)
        end

        it 'returns 20x status' do
          post api_path, params: { access_token: access_token.token, answer: attributes_for_answer }.to_json,
                         headers: headers

          expect(response).to be_successful
        end

        it 'returns saved answer with all public fields' do
          post api_path, params: { access_token: access_token.token, answer: attributes_for_answer }.to_json,
                         headers: headers

          %w[id body created_at updated_at].each do |attr|
            expect(json['answer'][attr]).to eq(Answer.first.send(attr).as_json)
          end
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

      it 'returns 20x status' do
        patch api_path, params: { access_token: access_token.token, answer: { body: 'Updated body' } }.to_json,
                        headers: headers

        expect(response).to be_successful
      end

      context 'invalid attributes' do
        it 'does not update answer in db' do
          patch api_path,
                params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }.to_json, headers: headers

          answer.reload

          expect(answer.body).to_not eq(nil)
        end

        it 'returns 422 status' do
          patch api_path,
                params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }.to_json, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'valid attributes' do
        context 'author of answer' do
          it 'updates answer in db' do
            patch api_path, params: { access_token: access_token.token, answer: { body: 'Updated body' } }.to_json,
                            headers: headers

            answer.reload

            expect(answer.body).to eq('Updated body')
          end

          it 'returns 20x status' do
            patch api_path, params: { access_token: access_token.token, answer: { body: 'Updated body' } }.to_json,
                            headers: headers

            expect(response).to be_successful
          end

          it 'returns updated answer with all public fields' do
            patch api_path, params: { access_token: access_token.token, answer: { body: 'Updated body' } }.to_json,
                            headers: headers

            %w[id body created_at updated_at].each do |attr|
              expect(json['answer'][attr]).to eq(Answer.first.send(attr).as_json)
            end
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

      context 'author of question' do
        it 'returns 20x status' do
          delete api_path,
                 params: { access_token: access_token.token, question_id: question.id, id: answer.id }.to_json, headers: headers

          expect(response).to be_successful
        end

        it 'deletes answer from db' do
          expect do
            delete api_path, params: { access_token: access_token.token, question_id: question.id, id: answer.id }.to_json,
                             headers: headers
          end.to change(Answer, :count).by(-1)
        end
      end
    end
  end
end
