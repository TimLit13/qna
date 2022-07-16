require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, user: user) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }
    before { get :index }

    it 'fill an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end
    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }
    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new question in db' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      # this spec for @question instance variable in controller
      # when local variable we shouldn't test it
      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to assigns(:question)
      end

      it 'broadcast new question' do
        login(user)
        expect do
          post :create, params: { question: attributes_for(:question) }
        end.to have_broadcasted_to('questions').from_channel(QuestionsChannel)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create,
               params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question, user: user) }

    context 'Authenticated user' do
      before { login(user) }
      context 'With valid attributes' do
        it 'changes question attributes' do
          patch :update, params: { id: question, question: { body: 'Edited question' } }, format: :js
          question.reload
          expect(question.body).to eq('Edited question')
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: { body: 'Edited question' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'With invalid attributes' do
        it 'not changes answer attributes' do
          expect do
            patch :update, params: { id: question, question: { body: nil } }, format: :js
          end.to_not change(question, :body)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:question) { create(:question, user: user) }
    it 'deletes question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end
    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end

  describe 'shared examples' do
    it_behaves_like 'voted' do
      let(:author) { create(:user) }
      let(:user) { create(:user) }
      let!(:resource) { create(:question, user: author) }
    end
  end
end
