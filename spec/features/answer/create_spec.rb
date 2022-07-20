require 'rails_helper'

feature 'User can create answer', '
  In order to answer the question
  User would like to be able to create the answer
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Can see form for create new answer' do
      expect(page).to have_selector(:link_or_button, 'Create answer')
    end

    scenario 'Can create an answer', js: true do
      # save_and_open_page
      within '.new-answer' do
        fill_in 'Body', with: 'Answer text'
        click_on 'Create answer'
      end

      expect(page).to have_content 'Your answer successfully created!'
      expect(page).to have_content 'Answer text'
    end

    scenario 'Create an answer with errors', js: true do
      click_on 'Create answer'
      expect(page).to have_content "can't be blank"
    end

    scenario 'answer with attached file', js: true do
      within '.new-answer' do
        fill_in 'Body', with: 'text text text'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Create answer'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'Can not create an answer' do
      within '.new-answer' do
        fill_in 'Body', with: 'Answer text'
        click_on 'Create answer'
      end

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'multisessions' do
    given(:first_user) { create(:user) }
    given(:second_user) { create(:user) }
    given(:question) { create(:question, user: first_user) }

    scenario 'create answer and second_user can see answer in real time', js: true do
      Capybara.using_session('second_user') do
        sign_in(second_user)
        visit question_path(question)
      end

      Capybara.using_session('first_user') do
        sign_in(first_user)
        visit question_path(question)

        within '.new-answer' do
          fill_in 'Body', with: 'New comet answer'
        end

        click_on 'Create answer'
      end

      Capybara.using_session('second_user') do
        within '.other-answers' do
          expect(page).to have_content 'New comet answer'
        end
      end
    end
  end
end
