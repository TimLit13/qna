require 'rails_helper'

feature 'User can delete question' do
  given(:user) { create(:user) }
  given(:not_author_user) { create(:user) }
  given(:question_author) { create(:user) }
  given(:question) { create(:question, user: question_author) }
  given(:question_with_files) { create(:question, :with_files, user: question_author) }
  given(:first_attached_file_name) { question_with_files.files.first.filename.to_s }

  describe 'Authenticated user' do
    describe 'Author of question' do
      background do
        sign_in(question_author)
        visit question_path(question_with_files)
      end

      scenario 'can delete his question' do
        click_on 'Delete question'

        expect(page).to have_content 'Question was successfully deleted'
        expect(page).to_not have_content question.body
      end

      scenario 'can delete his attachment', js: true do
        within('.question') do
          accept_alert { click_on 'Del', match: :first }

          expect(page).to_not have_content first_attached_file_name
        end
      end
    end

    describe 'Not author of question' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'can not delete author question' do
        expect(page).to_not have_selector(:link_or_button, 'Delete question')
      end

      scenario 'can not delete authors attachment', js: true do
        expect(page).to_not have_selector(:link_or_button, 'Del')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not delete question' do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Delete question')
    end

    scenario 'can not delete attachment', js: true do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Del')
    end
  end
end
