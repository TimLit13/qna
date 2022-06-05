require 'rails_helper'

feature 'User can mark answer as best', '
  In order to determine best answer
  User would like to be able to mark answer as best
' do
  given(:question_author) { create(:user) }
  given(:question) { create(:question, user: question_author) }
  given(:another_user) { create(:user) }
  given(:answer_author) { create(:user) }
  given!(:answer) { create(:answer, user: answer_author, question: question) }
  given(:another_answer) { create(:answer, user: answer_author, question: question) }

  describe 'Authenticated user' do
    describe 'user is author of question' do
      background do
        sign_in(question_author)
        visit question_path(question)
      end

      scenario 'marks answer as best', js: true do
        click_on 'Mark as best answer'

        # save_and_open_page
        within '.best-answer' do
          expect(page).to have_content answer.body
          expect(page).to_not have_selector('Mark as best answer')
        end

        within '.other-answers', visible: false do
          expect(page).to_not have_content answer.body
        end
      end

      scenario 'marks another answer as best', js: true do
        click_on 'Mark as best answer'
        another_answer

        click_on 'Mark as best answer'
        # save_and_open_page
        within '.best-answer' do
          expect(page).to have_content another_answer.body
          expect(page).to_not have_selector('Mark as best answer')
        end

        within '.other-answers' do
          expect(page).to have_content answer.body
        end
      end
    end

    describe 'user is not author of question' do
      background do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario 'can not marks answer as best', js: true do
        expect(page).to_not have_selector('Mark as best answer')
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'can not marks answer as best', js: true do
      expect(page).to_not have_selector('Mark as best answer')
    end
  end
end
