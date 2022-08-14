require 'rails_helper'

feature 'User can subscribe on the question', '
  In order to receive new answers for question
  User would like to be able to subscribe on question
' do
  given(:author) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Authenticated user not author' do
    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'can subscribe', js: true do
      within '.subscription' do
        expect(page).to have_selector(:link_or_button, 'Subscribe')
        click_on 'Subscribe'
        expect(page).to_not have_content 'Subscribe'
      end
    end

    scenario 'can not subscribe twice or more times', js: true do
      within '.subscription' do
        expect(page).to have_selector(:link_or_button, 'Subscribe')
        click_on 'Subscribe'
        expect(page).to have_no_selector(:link_or_button, 'Subscribe')
      end
    end
  end

  describe 'Authenticated user, author' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'can not subscribe twice', js: true do
      expect(page).to have_no_selector(:link_or_button, 'Subscribe')
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'can not subscribe' do
      save_and_open_page
      expect(page).to have_no_selector(:link_or_button, 'Subscribe')
    end
  end
end
