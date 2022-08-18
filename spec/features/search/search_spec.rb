require 'rails_helper'

feature 'User can search information', '
  In order to search information faster
  User would like to be able to search info
' do
  given(:users) { create_list(:user, 3) }
  given!(:questions) { create_list(:question, 3, user_id: users.first.id) }
  given!(:answers) { create_list(:answer, 3, user_id: users.second.id, question_id: questions.second.id) }
  given(:question_comments) { create_list(:comment, 3, user_id: users.last.id, commentable_id: questions.last.id) }
  given(:answer_comments) { create_list(:comment, 3, user_id: users.last.id, commentable_id: answers.last.id) }

  describe 'search form' do
    background { visit root_path }

    scenario 'Main page have search field' do
      within '.search' do
        expect(page).to have_selector('p.search-query-field')
      end
    end

    scenario 'Main page have search link or button' do
      within '.search' do
        expect(page).to have_selector(:link_or_button, 'Search')
      end
    end
  end
end
