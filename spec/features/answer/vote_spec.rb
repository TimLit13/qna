require 'rails_helper'

feature 'User can vote for answer', '
  In order to rate answers
  User would like to be able to vote for answer
' do
  given(:author) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  describe 'Authenticated user not author' do
    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'can rate up', js: true do
      within '.answers .rating' do
        expect(page).to have_selector(:link_or_button, 'Rate up')
        click_on 'Rate up'
        expect(page).to have_content '1'
      end
    end

    scenario 'can rate down', js: true do
      within '.answers .rating' do
        expect(page).to have_selector(:link_or_button, 'Rate down')
        click_on 'Rate down'
        expect(page).to have_content '-1'
      end
    end

    scenario 'can cancel rate', js: true do
      within '.answers .rating' do
        click_on 'Rate up'
        expect(page).to have_selector(:link_or_button, 'Cancel rate')
        click_on 'Cancel rate'
        expect(page).to have_content '0'
        expect(page).to have_no_selector(:link_or_button, 'Cancel rate')
      end
    end

    scenario 'can not cancel rate if not rate before', js: true do
      within '.answers .rating' do
        expect(page).to have_no_selector(:link_or_button, 'Cancel rate')
      end
    end

    scenario 'can rate after cancelling rate', js: true do
      within '.answers .rating' do
        click_on 'Rate up'
        click_on 'Cancel rate'
        click_on 'Rate up'
        expect(page).to have_content '1'
      end
    end

    scenario 'can not rate up twice or more times', js: true do
      within '.answers .rating' do
        click_on 'Rate up'
        expect(page).to have_no_selector(:link_or_button, 'Rate up')
        expect(page).to have_content '1'
      end
    end

    scenario 'can not rate down twice or more times', js: true do
      within '.answers .rating' do
        click_on 'Rate down'
        expect(page).to have_no_selector(:link_or_button, 'Rate down')
        expect(page).to have_content '-1'
      end
    end

    scenario 'can see current rate', js: true do
      within '.answers .rating-value' do
        expect(page).to have_content '0'
      end
    end
  end

  describe 'Authenticated user, author' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'can not rate up', js: true do
      within '.answers .rating' do
        expect(page).to have_no_selector(:link_or_button, 'Rate up')
      end
    end

    scenario 'can not rate down', js: true do
      within '.answers .rating' do
        expect(page).to have_no_selector(:link_or_button, 'Rate down')
      end
    end

    scenario 'can see current rate', js: true do
      within '.answers .rating-value' do
        expect(page).to have_content '0'
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'can not rate up' do
      within '.answers .rating' do
        expect(page).to have_no_selector(:link_or_button, 'Rate up')
      end
    end

    scenario 'can not rate down' do
      within '.answers .rating' do
        expect(page).to have_no_selector(:link_or_button, 'Rate down')
      end
    end

    scenario 'can see current rate' do
      within '.answers .rating-value' do
        expect(page).to have_content '0'
      end
    end
  end
end
