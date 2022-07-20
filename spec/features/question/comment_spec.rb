require 'rails_helper'

feature 'User can create comment to question', '
  In order to communicate in real time
  User should be able to create comment and
  Other users should be able to see it in real time
' do
  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: first_user) }

  describe 'Authenticated user' do
    background do
      sign_in(first_user)
      visit question_path(question)
    end

    scenario 'Can see form for create comment to question' do
      within ".question-id-#{question.id}-new-comment" do
        expect(page).to have_selector(:link_or_button, 'Create comment')
      end
    end

    scenario 'Can create a comment to question', js: true do
      within ".question-id-#{question.id}-new-comment" do
        fill_in 'Body', with: 'Comment text'
        click_on 'Create comment'
      end
      expect(page).to have_content 'Your comment successfully created!'
      expect(page).to have_content 'Comment text'
    end

    scenario 'Create a comment with errors', js: true do
      within ".question-id-#{question.id}-new-comment" do
        click_on 'Create comment'
      end
      expect(page).to have_content "can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'Can not create a comment' do
      within ".question-id-#{question.id}-new-comment" do
        fill_in 'Body', with: 'Comment text'
        click_on 'Create comment'
      end
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'multisessions' do
    scenario 'create comment to question and comment appears in second user session', js: true do
      Capybara.using_session('second_user') do
        sign_in(second_user)
        visit question_path(question)
      end

      Capybara.using_session('first_user') do
        sign_in(first_user)
        visit question_path(question)

        within ".question-id-#{question.id}-new-comment" do
          fill_in 'Body', with: 'New comet comment'
          click_on 'Create comment'
        end

        expect(page).to have_content('New comet comment')
      end

      Capybara.using_session('second_user') do
        expect(page).to have_content('New comet comment')
      end
    end
  end
end
