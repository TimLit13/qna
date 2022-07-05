require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:question) { create(:question, user: user) }
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let!(:link_google) { create(:link, :google, linkable: question) }
  let!(:link_github) { create(:link, :github, linkable: question) }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      context 'author of question' do
        before { login(user) }

        it 'can delete link' do
          delete :destroy, params: { id: question.links.first, format: :js }

          expect(question.links.count).to eq(1)
        end

        it 'not redirects' do
          delete :destroy, params: { id: question.links.first, format: :js }

          expect(response).to_not have_http_status(:redirect)
        end
      end

      context 'not author of question' do
        before { login(second_user) }

        it 'can not delete link' do
          delete :destroy, params: { id: question.links.first, format: :js }

          expect(question.links.count).to eq(2)
        end
      end

      context 'Unauthenticated user' do
        it 'can not delete link' do
          delete :destroy, params: { id: question.links.first, format: :js }

          expect(question.links.count).to eq(2)
        end
      end
    end
  end
end
