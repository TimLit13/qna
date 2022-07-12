require 'rails_helper'

feature 'User can create question', '
  In order to get answer from a community
  As an unauthenticated user
  User would like to be able to ask the question
' do
  given(:user) { create(:user) }
  # given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'Asks a question' do
      within '.new-question' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      click_on 'Ask'

      # save_and_open_page
      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'Asks a question with errors' do
      click_on 'Ask'
      expect(page).to have_content "can't be blank"
    end

    scenario 'Asks a question with attached file' do
      within '.new-question' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Tries to ask a question' do
      visit questions_path
      click_on 'Ask question'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'multisessions' do
    given(:first_user) { create(:user) }
    given(:second_user) { create(:user) }

    scenario 'ask question and second_user can see question in real time', js: true do
      Capybara.using_session('second_user') do
        sign_in(second_user)
        visit questions_path
      end

      Capybara.using_session('first_user') do
        sign_in(first_user)
        visit questions_path

        click_on 'Ask question'

        within '.new-question' do
          fill_in 'Title', with: 'Question with comet'
          fill_in 'Body', with: 'comet comet comet'
        end

        click_on 'Ask'
      end

      Capybara.using_session('second_user') do
        within '.questions-list' do
          expect(page).to have_content 'comet comet comet'
        end
      end
    end
  end
end
