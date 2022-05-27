require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, user: user) }
  let(:user) { create(:user) }
  let(:answer_params) { attributes_for(:answer) }
  let(:params) do
    { answer: answer_params, question_id: question }
  end

  describe 'POST #create' do
    context 'Authenticated user' do  
      before { login(user) }
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

    context 'Unauthenticated user' do
      context 'with valid attributes' do  
        it 'not saves a new answer in db' do
          expect do
            post :create, params: params
          end.to_not change(Answer, :count)
        end

        it 'redirect to login page' do
          post :create, params: params

          expect(response).to  redirect_to new_user_session_path
        end
      end
    end
    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: params.update(answer: { body: nil })
        end.to_not change(Answer, :count)
      end

      it 'redirect to login page' do
        post :create, params: params.update(answer: { body: nil })
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    context 'Authenticated user' do  
      before { login(user) }
      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end
      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Unauthenticated user' do
      it 'not deletes answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end
      it 'not redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
