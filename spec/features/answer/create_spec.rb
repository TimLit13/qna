require 'rails_helper'

feature 'User can create answer', '
  In order to answer the question
  User would like to be able to create the answer
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Can see form for create new answer' do
      expect(page).to have_selector(:link_or_button, 'Create answer')
    end

    scenario 'Can create an answer' do
      fill_in 'Body', with: 'Answer text'
      click_on 'Create answer'

      expect(page).to have_content 'Your answer successfully created!'
      expect(page).to have_content 'Answer text'
    end

    scenario 'Create an answer with errors' do
      click_on 'Create answer'
      expect(page).to have_content "can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'Can not create an answer' do
      fill_in 'Body', with: 'Answer text'
      click_on 'Create answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
