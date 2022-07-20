require 'rails_helper'

feature 'User can edit his question', '
  In order to correct mistakes
  User would like to be able to edit his question
' do
  given(:user) { create(:user) }
  given(:question_author) { create(:user) }
  given!(:question) { create(:question, user: question_author) }
  given(:another_question) { create(:question, user: user) }
  given(:link_google) { create(:link, :google, linkable: another_question) }

  describe 'Authenticated user' do
    scenario 'Edits his question', js: true do
      sign_in(question_author)
      visit question_path(question)
      click_on 'Edit'

      within "#edit-question-#{question.id}" do
        fill_in 'Body', with: 'Edited question'
        click_on 'Save'
      end

      within '.question' do
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited question'
        expect(page).to_not have_selector('textarea')
      end
    end

    scenario 'Edits his answer with errors', js: true do
      sign_in(question_author)
      visit question_path(question)

      click_on 'Edit'

      within "#edit-question-#{question.id}" do
        # save_and_open_page
        fill_in 'Body', with: nil
        click_on 'Save'
      end

      expect(page).to have_content question.body
      expect(page).to have_content 'error'
      expect(page).to have_selector('textarea')
    end

    scenario 'Tries to edit other user answer', js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Edit')
    end

    scenario 'Attach files', js: true do
      sign_in(question_author)
      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'add link', js: true do
      sign_in(question_author)
      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        click_on 'add link'

        fill_in 'Name', with: link_google.name
        fill_in 'Url', with: link_google.url

        click_on 'Save'

        expect(page).to have_link link_google.name, href: link_google.url
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
