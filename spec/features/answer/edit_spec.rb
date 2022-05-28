require 'rails_helper'

feature 'User can edit his answer', '
  In order to correct mistakes
  User would like to be able to edit his answer
' do
  given(:user) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: answer_author, question: question) }

  describe 'Authenticated user' do
    scenario 'Edits his answer', js: true do
      sign_in(answer_author)
      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'Edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).to_not have_selector('textarea')
      end
    end
    scenario 'Edits his answer with errors'
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

    scenario
  end
end
