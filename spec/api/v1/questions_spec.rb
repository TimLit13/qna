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

      it 'returns 20x status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq(questions.count)
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
          expect(question_response['answers'].size).to eq(answers.count)
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq(answer.send(attr).as_json)
          end
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

      it 'returns 20x status' do
        expect(response).to be_successful
      end

      it 'returns requested question' do
        expect(json['question']['id']).to eq(question.id)
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(json['question'][attr]).to eq(question.send(attr).as_json)
        end
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

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(json['question']['answers'].first[attr]).to eq(answer.send(attr).as_json)
          end
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }

        it 'returns list of answers' do
          expect(json['question']['comments'].count).to eq(comments.count)
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(json['question']['comments'].first[attr]).to eq(comment.send(attr).as_json)
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }

        it 'returns list of links' do
          expect(json['question']['links'].count).to eq(links.count)
        end

        it 'returns all public fields' do
          %w[name url].each do |attr|
            expect(json['question']['links'].first[attr]).to eq(link.send(attr).as_json)
          end
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
end
