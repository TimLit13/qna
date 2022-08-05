require 'rails_helper'

RSpec.describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable' do
        let(:method) { :get }
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
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'Successfull response'

      it 'returns list of questions' do
        expect(json['questions'].size).to eq(questions.count)
      end

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id title body created_at updated_at] }
        let(:resource) { question }
        let(:resource_response) { question_response }
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
          expect(question_response['answers'].size).to eq(answers.count)
        end

        it_behaves_like 'Public fields' do
          let(:attributes) { %w[id body created_at updated_at] }
          let(:resource) { answer }
          let(:resource_response) { answer_response }
        end
      end
    end
  end

  describe 'GET /api/v1/question/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_files, user: user) }
    let!(:answers) { create_list(:answer, 3, user: user, question: question) }
    let!(:comments) { create_list(:comment, 3, user: user, commentable: question) }
    let!(:links) { create_list(:link, 3, :google, linkable: question) }
    let!(:api_path) { "/api/v1/questions/#{question.id}" }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable' do
        let(:method) { :get }
        let(:path) { api_path }
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        get api_path, params: { access_token: access_token.token, id: question.id }, headers: headers
      end

      it_behaves_like 'Successfull response'

      it 'returns requested question' do
        expect(json['question']['id']).to eq(question.id)
      end

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id title body created_at updated_at] }
        let(:resource) { question }
        let(:resource_response) { json['question'] }
      end

      it 'contains user object' do
        expect(json['question']['user']['id']).to eq(question.user.id)
      end

      it 'contains short title' do
        expect(json['question']['short_title']).to eq(question.title.truncate(7))
      end

      describe 'answers' do
        let(:answer) { answers.first }

        it 'returns list of answers' do
          expect(json['question']['answers'].count).to eq(answers.count)
        end

        it_behaves_like 'Public fields' do
          let(:attributes) { %w[id body created_at updated_at] }
          let(:resource) { answer }
          let(:resource_response) { json['question']['answers'].first }
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }

        it 'returns list of answers' do
          expect(json['question']['comments'].count).to eq(comments.count)
        end

        it_behaves_like 'Public fields' do
          let(:attributes) { %w[id body created_at updated_at] }
          let(:resource) { comment }
          let(:resource_response) { json['question']['comments'].first }
        end
      end

      describe 'links' do
        let(:link) { links.first }

        it 'returns list of links' do
          expect(json['question']['links'].count).to eq(links.count)
        end

        it_behaves_like 'Public fields' do
          let(:attributes) { %w[name url] }
          let(:resource) { link }
          let(:resource_response) { json['question']['links'].first }
        end
      end

      describe 'files' do
        let(:file) { question.files.first }

        it 'returns list of files' do
          expect(json['question']['files'].count).to eq(question.files.count)
        end

        it 'returns url of file' do
          expect(json['question']['files'].first['url']).to include(file.blob.filename.to_s)
        end
      end
    end
  end

  describe 'POST /api/v1/question/' do
    let(:user) { create(:user) }
    let!(:api_path) { '/api/v1/questions/' }

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
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }.to_json,
                         headers: headers
        end
      end

      context 'invalid attributes' do
        before do
          post api_path,
               params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }.to_json, headers: headers
        end

        it 'does not save new question in db' do
          expect(Question.count).to eq(0)
        end

        it 'returns 422 status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'valid attributes' do
        let(:attributes_for_question) { attributes_for(:question) }

        before do
          post api_path, params: { access_token: access_token.token, question: attributes_for_question }.to_json,
                         headers: headers
        end

        it 'saves new question in db' do
          expect(Question.count).to eq(1)
        end

        it_behaves_like 'Successfull response'

        it_behaves_like 'Public fields' do
          let(:attributes) { %w[id title body created_at updated_at] }
          let(:resource) { Question.first }
          let(:resource_response) { json['question'] }
        end
      end
    end
  end

  describe 'PATCH /api/v1/question/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_files, user: user) }
    let!(:answers) { create_list(:answer, 3, user: user, question: question) }
    let!(:comments) { create_list(:comment, 3, user: user, commentable: question) }
    let!(:links) { create_list(:link, 3, :google, linkable: question) }
    let!(:api_path) { "/api/v1/questions/#{question.id}" }

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
          patch api_path, params: { access_token: access_token.token, question: { title: 'Updated title' } }.to_json,
                          headers: headers
        end
      end

      context 'invalid attributes' do
        before do
          patch api_path,
                params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }.to_json, headers: headers
        end
        it 'does not update question in db' do
          question.reload

          expect(question.title).to_not eq(nil)
        end

        it 'returns 422 status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'valid attributes' do
        context 'author of question' do
          before do
            patch api_path, params: { access_token: access_token.token, question: { title: 'Updated title' } }.to_json,
                            headers: headers
          end

          it 'update question in db' do
            question.reload

            expect(question.title).to eq('Updated title')
          end

          it_behaves_like 'Successfull response'

          it_behaves_like 'Public fields' do
            let(:attributes) { %w[id title body created_at updated_at] }
            let(:resource) { Question.first }
            let(:resource_response) { json['question'] }
          end
        end

        context 'user is not author of question' do
          let(:not_author_user) { create(:user) }
          let(:other_question) { create(:question, user: not_author_user) }
          let!(:other_api_path) { "/api/v1/questions/#{other_question.id}" }

          it 'does not update question in db' do
            patch other_api_path, params: { access_token: access_token.token, question: { title: 'Updated title' } }.to_json,
                                  headers: headers

            other_question.reload

            expect(other_question.title).to_not eq('Updated title')
          end
        end
      end
    end
  end

  describe 'DELETE /api/v1/question/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, :with_files, user: user) }
    let!(:answers) { create_list(:answer, 3, user: user, question: question) }
    let!(:comments) { create_list(:comment, 3, user: user, commentable: question) }
    let!(:links) { create_list(:link, 3, :google, linkable: question) }
    let!(:api_path) { "/api/v1/questions/#{question.id}" }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable' do
        let(:method) { :delete }
        let(:path) { api_path }
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'author of question' do
        before do
          delete api_path, params: { access_token: access_token.token }.to_json, headers: headers
        end

        it_behaves_like 'Successfull response'

        it 'deletes question from db' do
          expect(Question.count).to eq(0)
        end
      end

      context 'user is not author of question' do
        let(:not_author_user) { create(:user) }
        let(:other_question) { create(:question, user: not_author_user) }
        let!(:other_api_path) { "/api/v1/questions/#{other_question.id}" }

        it 'does not delete question from db' do
          expect do
            delete other_api_path, params: { access_token: access_token.token }.to_json, headers: headers
          end.to_not change(Question, :count)
        end
      end
    end
  end
end
