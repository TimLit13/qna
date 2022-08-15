require 'rails_helper'

feature 'User can subscribe or unsubscribe on the question', '
  In order to receive new answers for question
  User would like to be able to subscribe or unsubscribe on question
' do
  given(:author) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  context 'user can subscribe' do
    describe 'Authenticated user not author' do
      background do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario 'can subscribe', js: true do
        within '.subscription' do
          expect(page).to have_selector(:link_or_button, 'Subscribe')
          click_on 'Subscribe'
          expect(page).to_not have_content 'Subscribe'
        end
      end

      scenario 'can not subscribe twice or more times', js: true do
        within '.subscription' do
          expect(page).to have_selector(:link_or_button, 'Subscribe')
          click_on 'Subscribe'
          expect(page).to have_no_selector(:link_or_button, 'Subscribe')
        end
      end
    end

    describe 'Authenticated user, author' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'can not subscribe twice', js: true do
        expect(page).to have_no_selector(:link_or_button, 'Subscribe')
      end
    end

    describe 'Unauthenticated user' do
      background do
        visit question_path(question)
      end

      scenario 'can not subscribe' do
        expect(page).to have_no_selector(:link_or_button, 'Subscribe')
      end
    end
  end

  context 'user can unsubscribe' do
    describe 'Authenticated user not author' do
      given!(:subscription) { create(:subscription, question_id: question.id, user_id: another_user.id) }

      background do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario 'can unsubscribe', js: true do
        within '.subscription' do
          expect(page).to have_selector(:link_or_button, 'Unsubscribe')
          click_on 'Unsubscribe'
          expect(page).to_not have_content 'Unsubscribe'
          expect(page).to have_content 'Subscribe'
        end
      end

      scenario 'can not unsubscribe twice or more times', js: true do
        within '.subscription' do
          expect(page).to have_selector(:link_or_button, 'Unsubscribe')
          click_on 'Unsubscribe'
          expect(page).to have_no_selector(:link_or_button, 'Unsubscribe')
          expect(page).to have_selector(:link_or_button, 'Subscribe')
        end
      end
    end

    describe 'Authenticated user, author' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'can unsubscribe', js: true do
        expect(page).to have_selector(:link_or_button, 'Unsubscribe')
        click_on 'Unsubscribe'
        expect(page).to have_no_selector(:link_or_button, 'Unsubscribe')
        expect(page).to have_selector(:link_or_button, 'Subscribe')
      end

      scenario 'can not unsubscribe twice or more times', js: true do
        within '.subscription' do
          expect(page).to have_selector(:link_or_button, 'Unsubscribe')
          click_on 'Unsubscribe'
          expect(page).to have_no_selector(:link_or_button, 'Unsubscribe')
          expect(page).to have_selector(:link_or_button, 'Subscribe')
        end
      end
    end

    describe 'Unauthenticated user' do
      background do
        visit question_path(question)
      end

      scenario 'can not subscribe' do
        expect(page).to have_no_selector(:link_or_button, 'Unsubscribe')
      end
    end
  end
end
