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
            post :create, params: params, format: :js
          end.to change(Answer, :count).by(1)
        end

        it 'redirect to show view' do
          post :create, params: params, format: :js

          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect do
            post :create, params: params.update(answer: { body: nil }), format: :js
          end.to_not change(Answer, :count)
        end

        it 're-renders new view' do
          post :create, params: params.update(answer: { body: nil }), format: :js
          expect(response).to render_template :create
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

          expect(response).to redirect_to new_user_session_path
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
      it 'not redirects to question' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to_not redirect_to question_path(question)
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

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Authenticated user' do
      before { login(user) }
      context 'With valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'Edited answer' } }, format: :js
          answer.reload
          expect(answer.body).to eq('Edited answer')
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'Edited answer' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'With invalid attributes' do
        it 'not changes answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: { body: nil } }, format: :js
          end.to_not change(answer, :body)
        end
      end
    end
  end

  describe 'PATCH #mark_answer_as_best' do
    let(:question) { create(:question, user: user) }
    let!(:user_answer) { create(:answer, question: question, user: user) }
    let(:answer_author) { create(:user) }
    let!(:another_answer) { create(:answer, question: question, user: answer_author) }

    context 'Authenticated user' do
      context 'user is author for question' do
        before { login(user) }

        it 'marks his own answer as best' do
          patch :mark_answer_as_best, params: { id: user_answer }, format: :js
          question.reload
          expect(question.best_answer).to eq(user_answer)
        end

        it 'marks not his answer as best' do
          patch :mark_answer_as_best, params: { id: another_answer }, format: :js
          question.reload
          expect(question.best_answer).to eq(another_answer)
        end
      end

      context 'user is not author for question' do
        before { login(answer_author) }
        it 'can not marks answer as best' do
          patch :mark_answer_as_best, params: { id: user_answer }, format: :js
          question.reload
          expect(question.best_answer).to_not eq(user_answer)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can not marks answer as best' do
        expect do
          patch :mark_answer_as_best, params: { id: user_answer }, format: :js
        end.to_not change(question, :best_answer_id)
      end
    end
  end
end
