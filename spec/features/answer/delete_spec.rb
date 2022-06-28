require 'rails_helper'

feature 'User can delete answer' do
  given(:user) { create(:user) }
  given(:not_author_user) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer_with_files) { create(:answer, :with_files, user: answer_author, question: question) }
  given(:first_attached_file_name) { answer_with_files.files.first.filename.to_s }

  describe 'Authenticated user' do
    describe 'Author of answer' do
      background do
        sign_in(answer_author)
        visit question_path(question)
      end

      scenario 'can delete his answer', js: true do
        accept_alert { click_on 'Delete answer' }

        expect(page).to have_content 'Answer was successfully deleted.'
        expect(page).to_not have_content answer_with_files.body
      end

      scenario 'can delete his attachment', js: true do
        within('.answers') do
          accept_alert { click_on 'Del', match: :first }

          expect(page).to_not have_content first_attached_file_name
        end
      end
    end

    describe 'Not author of answer' do
      background do
        sign_in(not_author_user)
        visit question_path(question)
      end

      scenario 'can not delete authors answer', js: true do
        expect(page).to_not have_selector(:link_or_button, 'Delete answer')
      end

      scenario 'can not delete authors attachment', js: true do
        expect(page).to_not have_selector(:link_or_button, 'Del')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not delete answer', js: true do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Delete answer')
    end

    scenario 'can not delete attachment', js: true do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Del')
    end
  end
end
