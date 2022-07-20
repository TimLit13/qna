require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:comment_params_to_answer) do
    { comment: attributes_for(:comment), answer_id: answer }
  end
  let(:comment_params_to_question) do
    { comment: attributes_for(:comment), answer_id: answer }
  end

  describe 'POST #create' do
    context 'Comment to answer' do
      context 'Authenticated user' do
        before { login(user) }
        context 'with valid attributes' do
          it 'saves a new coment to answer in db' do
            expect do
              post :create, params: comment_params_to_answer, format: :js
            end.to change(Comment, :count).by(1)
          end

          it 'redirect to show view' do
            post :create, params: comment_params_to_answer, format: :js

            expect(response).to render_template :create
          end
        end

        context 'with invalid attributes' do
          it 'does not save the comment to answer' do
            expect do
              post :create, params: comment_params_to_answer.update(comment: { body: nil }), format: :js
            end.to_not change(Comment, :count)
          end

          it 're-renders new view' do
            post :create, params: comment_params_to_answer.update(comment: { body: nil }), format: :js
            expect(response).to render_template :create
          end
        end
      end

      context 'Unauthenticated user' do
        context 'with valid attributes' do
          it 'not saves a new comment in db' do
            expect do
              post :create, params: comment_params_to_answer
            end.to_not change(Comment, :count)
          end

          it 'redirect to login page' do
            post :create, params: comment_params_to_answer

            expect(response).to redirect_to new_user_session_path
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect do
            post :create, params: comment_params_to_answer.update(comment: { body: nil })
          end.to_not change(Comment, :count)
        end

        it 'redirect to login page' do
          post :create, params: comment_params_to_answer.update(comment: { body: nil })
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    context 'Comment to question' do
      context 'Authenticated user' do
        before { login(user) }
        context 'with valid attributes' do
          it 'saves a new coment to question in db' do
            expect do
              post :create, params: comment_params_to_question, format: :js
            end.to change(Comment, :count).by(1)
          end

          it 'redirect to show view' do
            post :create, params: comment_params_to_question, format: :js

            expect(response).to render_template :create
          end
        end

        context 'with invalid attributes' do
          it 'does not save the comment to question' do
            expect do
              post :create, params: comment_params_to_question.update(comment: { body: nil }), format: :js
            end.to_not change(Comment, :count)
          end

          it 're-renders new view' do
            post :create, params: comment_params_to_question.update(comment: { body: nil }), format: :js
            expect(response).to render_template :create
          end
        end
      end

      context 'Unauthenticated user' do
        context 'with valid attributes' do
          it 'not saves a new comment in db' do
            expect do
              post :create, params: comment_params_to_question
            end.to_not change(Comment, :count)
          end

          it 'redirect to login page' do
            post :create, params: comment_params_to_question

            expect(response).to redirect_to new_user_session_path
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect do
            post :create, params: comment_params_to_question.update(comment: { body: nil })
          end.to_not change(Comment, :count)
        end

        it 'redirect to login page' do
          post :create, params: comment_params_to_question.update(comment: { body: nil })
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
