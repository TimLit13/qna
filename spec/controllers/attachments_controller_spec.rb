require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:question) { create(:question, :with_files, user: user) }
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      context 'author of question' do
        before { login(user) }

        it 'can delete attachment' do
          delete :destroy, params: { id: question.files.records.first, format: :js }
          question.reload

          expect(question.files.records.length).to eq(1)
        end

        it 'not redirects' do
          delete :destroy, params: { id: question.files.records.first, format: :js }

          expect(response).to_not have_http_status(:redirect)
        end
      end

      context 'not author of question' do
        before { login(second_user) }

        it 'can not delete attachment' do
          delete :destroy, params: { id: question.files.records.first, format: :js }
          question.reload

          expect(question.files.records.length).to eq(2)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can not delete attachment' do
        delete :destroy, params: { id: question.files.records.first, format: :js }
        question.reload

        expect(question.files.records.length).to eq(2)
      end
    end
  end
end

# TODO: S3, yandex
