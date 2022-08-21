require 'sphinx_helper'

RSpec.describe SearchesController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user_id: user.id) }
  let!(:query_from_page) { { entity: Question, query: question.title } }
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'assigns search result variable' do
      get :index, params: query_from_page

      expect(assigns(:search_results)).to be_an(Array)
    end
  end
end
