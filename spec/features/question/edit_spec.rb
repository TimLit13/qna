require 'rails_helper'

feature 'User can edit his question', '
  In order to correct mistakes
  User would like to be able to edit his question
' do
  given(:user) { create(:user) }
  given(:question_author) { create(:user) }
  given!(:question) { create(:question, user: question_author) }

  describe 'Authenticated user' do
    scenario 'Edits his question', js: true do
      sign_in(question_author)
      visit question_path(question)
      click_on 'Edit'

      within '.question' do
        fill_in 'Body', with: 'Edited question'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited question'
        expect(page).to_not have_selector('textarea')
      end
    end

    scenario 'Edits his answer with errors', js: true do
      sign_in(question_author)
      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        fill_in 'Body', with: nil
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_content 'error'
        expect(page).to have_selector('textarea')
      end
    end

    scenario 'Tries to edit other user answer', js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Edit')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Can not edit answer', js: true do
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Edit')
    end
  end
end
