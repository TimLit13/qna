require 'rails_helper'

feature 'User can create comment to answer', '
  In order to communicate in real time
  User should be able to create comment and
  Other users should be able to see it in real time
' do
  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: first_user) }
  given!(:answer) { create(answer, question: question, user: first_user) }

  describe 'Authenticated user' do
    background do
      sign_in(first_user)
      visit question_path(question)
    end

    scenario 'Can see form for create comment to answer' do
      within '.answers .comments' do
        expect(page).to have_selector(:link_or_button, 'Create comment')
      end
    end

    scenario 'Can create a comment to answer', js: true do
      within '.answers .comments' do
        fill_in 'Body', with: 'Comment text'
        click_on 'Create comment'

        expect(page).to have_content 'Your comment successfully created!'
        expect(page).to have_content 'Comment text'
      end
    end

    scenario 'Create a comment with errors', js: true do
      within '.answers .comments' do
        click_on 'Create comment'
        expect(page).to have_content "can't be blank"
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'Can not create a comment' do
      within '.answers .comments' do
        fill_in 'Body', with: 'Comment text'
        click_on 'Create comment'

        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe 'multisessions' do
    scenario 'create comment to answer and comment appears in second user session', js: true do
      Capybara.using_session('second_user') do
        sign_in(second_user)
        visit question_path(question)
      end

      Capybara.using_session('first_user') do
        sign_in(first_user)
        visit question_path(question)

        within '.answers .comments' do
          fill_in 'Body', 'New comet comment'
          click_on 'Create comment'
          expect(page).to have_content('New comet comment')
        end
      end

      Capybara.using_session('second_user') do
        within '.answers .comments' do
          expect(page).to have_content('New comet comment')
        end
      end
    end
  end
end
