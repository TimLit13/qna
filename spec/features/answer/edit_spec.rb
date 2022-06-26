require 'rails_helper'

feature 'User can edit his answer', '
  In order to correct mistakes
  User would like to be able to edit his answer
' do
  given(:user) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:new_user) { create(:user) }
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

    scenario 'Edits his answer with errors', js: true do
      sign_in(answer_author)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: nil
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content 'error'
        expect(page).to have_selector('textarea')
      end
    end

    scenario 'Tries to edit other user answer', js: true do
      sign_in(new_user)
      visit question_path(question)

      # save_and_open_page

      expect(page).to_not have_selector(:link_or_button, 'Edit')
    end

    scenario 'Attach files', js: true do
      sign_in(answer_author)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Can not edit answer', js: true do
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Edit')
    end
  end
end
