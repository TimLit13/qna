require 'rails_helper'

shared_examples_for 'voted' do
  before { @params = { id: resource, format: :json } }

  describe 'PUT #rate_up' do
    context 'Authenticated user not author' do
      before { login(user) }

      it 'saves a new vote in db' do
        expect do
          put :rate_up, params: @params
        end.to change(Vote, :count).by(1)
      end

      it 'assigns votable' do
        put :rate_up, params: @params
        expect(assigns(:votable)).to eq(resource)
      end

      it 'rate up rating' do
        put :rate_up, params: @params
        expect(resource.total_rating).to eq(1)
      end

      it 'not rate up if rate twice' do
        put :rate_up, params: @params
        put :rate_up, params: @params
        expect(resource.votes.last.rating).to eq(1)
      end

      it 'has 20x status code' do
        put :rate_up, params: @params
        expect(response.status).to eq(200)
      end

      it 'responds to json format' do
        put :rate_up, params: @params
        expect(response.content_type).to include('json')
      end
    end

    context 'Authenticated user as author' do
      before { login(author) }

      it 'not saves a new vote in db' do
        expect do
          put :rate_up, params: @params
        end.to_not change(Vote, :count)
      end

      it 'assigns votable' do
        put :rate_up, params: @params
        expect(assigns(:votable)).to eq(resource)
      end

      it 'responds to json format' do
        put :rate_up, params: @params
        expect(response.content_type).to include('json')
      end

      it 'render json with errors' do
        put :rate_up, params: @params
        expect(response.body).to include('unprocessable_entity')
        expect(response.body).to include('error')
      end
    end

    context 'Unauthenticated user' do
      it 'not saves a new vote in db' do
        expect do
          put :rate_up, params: @params
        end.to_not change(Vote, :count)
      end

      it 'assigns votable' do
        put :rate_up, params: @params
        expect(assigns(:votable)).to eq(resource)
      end

      it 'responds to json format' do
        put :rate_up, params: @params
        expect(response.content_type).to include('json')
      end

      it 'render json with errors' do
        put :rate_up, params: @params
        expect(response.status).to eq(401)
        expect(response.body).to include('error')
      end
    end
  end

  describe 'PUT #rate_down' do
    context 'Authenticated user not author' do
      before { login(user) }

      it 'saves a new vote in db' do
        expect do
          put :rate_down, params: @params
        end.to change(Vote, :count).by(1)
      end

      it 'assigns votable' do
        put :rate_down, params: @params
        expect(assigns(:votable)).to eq(resource)
      end

      it 'rate down rating' do
        put :rate_down, params: @params
        expect(resource.votes.last.rating).to eq(-1)
      end

      it 'not rate down if rate twice' do
        put :rate_down, params: @params
        put :rate_down, params: @params
        expect(resource.total_rating).to eq(-1)
      end

      it 'has 20x status code' do
        put :rate_down, params: @params
        expect(response.status).to eq(200)
      end

      it 'responds to json format' do
        put :rate_down, params: @params
        expect(response.content_type).to include('json')
      end
    end
  end

  context 'Authenticated user as author' do
    before { login(author) }

    it 'not saves a new vote in db' do
      expect do
        put :rate_down, params: @params
      end.to_not change(Vote, :count)
    end

    it 'assigns votable' do
      put :rate_down, params: @params
      expect(assigns(:votable)).to eq(resource)
    end

    it 'responds to json format' do
      put :rate_down, params: @params, format: :js

      expect(response.content_type).to include('json')
    end

    it 'render json with errors' do
      put :rate_down, params: @params, format: :js
      expect(response.body).to include('unprocessable_entity')
      expect(response.body).to include('error')
    end
  end

  context 'Unauthenticated user' do
    it 'not saves a new vote in db' do
      expect do
        put :rate_down, params: @params
      end.to_not change(Vote, :count)
    end

    it 'assigns votable' do
      put :rate_down, params: @params
      expect(assigns(:votable)).to eq(resource)
    end

    it 'responds to json format' do
      put :rate_down, params: @params
      expect(response.content_type).to include('json')
    end

    it 'render json with errors' do
      put :rate_down, params: @params
      expect(response.status).to eq(401)
      expect(response.body).to include('error')
    end
  end

  describe 'DELETE #cancel_rate' do
    context 'Authenticated user not author' do
      before { login(user) }

      context 'voted before' do
        before { put :rate_up, params: @params }

        it 'cancel vote from db' do
          expect do
            delete :cancel_rate, params: @params
          end.to change(Vote, :count).by(-1)
        end

        it 'change total rating' do
          delete :cancel_rate, params: @params
          expect(resource.total_rating).to eq(0)
        end

        it 'assigns votable' do
          delete :cancel_rate, params: @params
          expect(assigns(:votable)).to eq(resource)
        end

        it 'responds to json format' do
          delete :cancel_rate, params: @params
          expect(response.content_type).to include('json')
        end

        it 'has 20x status code' do
          delete :cancel_rate, params: @params
          expect(response.status).to eq(200)
        end
      end

      context 'not voted before' do
        it 'not cancel vote from db' do
          expect do
            delete :cancel_rate, params: @params
          end.to_not change(Vote, :count)
        end

        it 'not change total rating' do
          delete :cancel_rate, params: @params
          expect(resource.total_rating).to eq(0)
        end
      end
    end

    context 'Authenticated user as author' do
      before { login(author) }
      it 'not cancel vote from db' do
        expect do
          delete :cancel_rate, params: @params
        end.to_not change(Vote, :count)
      end

      it 'not change total rating' do
        delete :cancel_rate, params: @params
        expect(resource.total_rating).to eq(0)
      end
    end

    context 'Unauthenticated' do
      it 'not cancel vote from db' do
        expect do
          delete :cancel_rate, params: @params
        end.to_not change(Vote, :count)
      end

      it 'not change total rating' do
        delete :cancel_rate, params: @params
        expect(resource.total_rating).to eq(0)
      end

      it 'responds to json format' do
        delete :cancel_rate, params: @params
        expect(response.content_type).to include('json')
      end

      it 'render json with errors' do
        delete :cancel_rate, params: @params
        expect(response.status).to eq(401)
        expect(response.body).to include('error')
      end
    end
  end
end
