require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:awards) { create_list(:award, 3, question: question, user: user) }

  describe 'GET #index' do
    context 'authenicated user' do
      it 'assigns awards' do
        login(user)
        get :index
        expect(assigns(:awards)).to match_array(awards)
      end
    end

    context 'unauthenicated user' do
      it 'not assigns awards' do
        login(other_user)
        get :index
        expect(assigns(:awards)).to_not match_array(awards)
      end
    end
  end
end
