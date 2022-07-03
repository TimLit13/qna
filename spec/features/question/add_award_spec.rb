require 'rails_helper'

feature 'User can add award to question', '
  In order to award author of the most useful answer
  User would like to be able to create award
' do
  given(:question_author) { create(:user) }
  given(:best_answer_author) { create(:user) }

  describe 'create question' do
    background do
      sign_in(question_author)
      visit new_question_path
    end

    scenario 'user can create question with award' do
      within '.new-question' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      within '#award' do
        fill_in 'Title', with: 'Award'
        attach_file 'Image', "#{Rails.root}/spec/support/ruby.jpeg"
      end

      click_on 'Ask'

      expect(page).to have_content 'with award'
    end

    scenario 'uuser can create question with award' do
      within '.new-question' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      click_on 'Ask'

      expect(page).to have_no_content 'with award'
    end
  end
end
