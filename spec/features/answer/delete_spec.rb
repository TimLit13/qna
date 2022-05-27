require 'rails_helper'

feature 'User can delete answer' do
  given(:user) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: answer_author, question: question) }

  describe 'Authenticated user' do
    scenario 'Author can delete his answer' do
      sign_in(answer_author)
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_content 'Answer was successfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario 'Other user can not delete authors answer' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Delete answer')
    end
  end

  describe 'Unuthenticated user' do
    scenario 'User can not delete answer' do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Delete answer')
    end
  end
end
