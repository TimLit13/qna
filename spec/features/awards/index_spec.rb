require 'rails_helper'

feature 'User can see his awards', '
  In order to his awards
  User would like to see his awards
' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:first_question) { create(:question, user: user) }
  given(:second_question) { create(:question, user: user) }
  given!(:first_award) { create(:award, user: user, question: first_question) }
  given!(:second_award) { create(:award, user: user, question: second_question) }

  describe 'Authenticated user' do
    describe 'has awards' do
      background do
        sign_in(user)
        visit awards_path
      end

      scenario 'can see his awards' do
        expect(page).to have_content first_award.title
        expect(page).to have_content second_award.title
        expect(page).to have_css 'img'
      end
    end

    describe 'has no awards' do
      background do
        sign_in(another_user)
        visit awards_path
      end

      scenario 'can see no awards' do
        expect(page).to have_no_content first_award.title
        expect(page).to have_no_css 'img'
        expect(page).to have_content 'No awards yet'
      end
    end

    describe 'Unauthenticated user' do
      background { visit awards_path }

      scenario 'can not see no awards' do
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
  end
end
