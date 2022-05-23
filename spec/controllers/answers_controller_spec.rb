require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, user: user) }
  let(:user) { create(:user) }
  let(:answer_params) { attributes_for(:answer) }
  let(:params) do
    { answer: answer_params, question_id: question }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in db' do
        # count = Answer.count

        expect do
          post :create, params: params
        end.to change(Answer, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: params

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: params.update(answer: { body: nil })
        end.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: params.update(answer: { body: nil })
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
