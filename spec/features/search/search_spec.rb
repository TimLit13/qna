require 'sphinx_helper'

feature 'User can search information', '
  In order to search information faster
  User would like to be able to search info
' do
  given!(:users) { create_list(:user, 3) }
  given!(:questions) { create_list(:question, 3, user_id: users.first.id) }
  given!(:answers) { create_list(:answer, 3, user_id: users.second.id, question_id: questions.second.id) }
  given!(:question_comments) { create_list(:comment, 3, user_id: users.last.id, commentable: questions.last) }

  describe 'search form' do
    background { visit root_path }

    scenario 'Main page have search field' do
      within '.search' do
        expect(page).to have_selector('p.search-query-field')
      end
    end

    scenario 'Main page have select field' do
      within '.search' do
        expect(page).to have_selector('p.search-entity')
      end
    end

    scenario 'Main page have search link or button' do
      within '.search' do
        expect(page).to have_selector(:link_or_button, 'Search')
      end
    end
  end

  describe 'search across', sphinx: true, js: true do
    background { visit questions_path }

    context 'query does not have all need data' do
      SearchService::ENTITIES.each do |entity|
        scenario "search across #{entity}" do
          ThinkingSphinx::Test.run do
            within '.search' do
              click_on 'Search'
            end

            expect(page).to have_content('Nothing found')
          end
        end
      end
    end

    context 'query has all need data' do
      scenario 'search across All website' do
        ThinkingSphinx::Test.run do
          within '.search' do
            fill_in :query, with: Question.first.title
            select 'Question', from: 'entity'

            click_on 'Search'
          end

          expect(page).to have_content(Question.first.title)
        end
      end

      scenario 'search across Question' do
        ThinkingSphinx::Test.run do
          within '.search' do
            fill_in :query, with: Question.first.title
            select 'Question', from: 'entity'

            click_on 'Search'
          end

          expect(page).to have_content(Question.first.title)
        end
      end

      scenario 'search across Answer' do
        ThinkingSphinx::Test.run do
          within '.search' do
            fill_in :query, with: Answer.first.body
            select 'Answer', from: 'entity'

            click_on 'Search'
          end

          expect(page).to have_content(Answer.first.body)
        end
      end

      scenario 'search across Comment' do
        ThinkingSphinx::Test.run do
          within '.search' do
            fill_in :query, with: Comment.first.body
            select 'Comment', from: 'entity'

            click_on 'Search'
          end

          expect(page).to have_content(Comment.first.body)
        end
      end

      scenario 'search across User' do
        ThinkingSphinx::Test.run do
          within '.search' do
            fill_in :query, with: User.first.email
            select 'User', from: 'entity'

            click_on 'Search'
          end

          expect(page).to have_content(User.first.email)
        end
      end
    end
  end
end
