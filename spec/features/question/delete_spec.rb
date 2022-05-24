require 'rails_helper'

feature 'User can delete quetion' do
  given(:user) { create(:user) }
  given(:question_author) { create(:user) }
  given(:question) { create(:question, user: question_author) }

  describe 'Authenticated user' do
    scenario 'Author can delete his question' do
      sign_in(question_author)
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Question was successfully deleted'
      expect(page).to_not have_content question.body
    end
    scenario 'Other user can not delete author question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end
  end

  describe 'Unuthenticated user' do
    scenario 'User can not delete question' do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end 
  end
end
