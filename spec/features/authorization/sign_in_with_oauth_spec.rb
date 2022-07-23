require 'rails_helper'

feature 'User can sign in with github oauth2', '
  In order to ask questions
  As an unauthenticated user
  User would like to be able to sign in
  with his github account
' do
  # given(:user) { create(:user) }

  background { visit new_user_session_path }

  describe 'github oauth' do
    scenario 'user can be able to sign in with github' do
      expect(page).to have_content 'Sign in with GitHub'
    end

    context 'github provides email' do
      scenario 'user can sign in with github' do
        mock_auth_hash(:github)
        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Successfully authenticated from Github account'
      end
    end

    context 'github does not provide email' do
      background do
        mock_auth_hash(:github)[:info][:email] = nil
        click_on 'Sign in with GitHub'
        clear_emails
      end

      scenario 'user can see form for enter his email' do
        expect(page).to have_content 'Please, enter your email'
      end

      scenario 'user can enter his email' do
        fill_in 'email', with: 'test@test.com'
        click_on 'Submit'
        expect(page).to have_content 'Confirmation email sent to your email. Please confirm before'
      end

      scenario 'user can takes confirmation email' do
        fill_in 'email', with: 'test@test.com'
        click_on 'Submit'

        open_email('test@test.com')
        expect(current_email).to have_content 'Confirm email'
      end

      scenario 'user can sign in after confirmation email' do
        fill_in 'email', with: 'test@test.com'
        click_on 'Submit'

        open_email('test@test.com')
        current_email.click_link 'Confirm'

        expect(page).to have_content 'Your email Successfully confirmed'
      end
    end
  end

  describe 'vkontakte oauth' do
    scenario 'user can be able to sign in with vkontakte' do
      expect(page).to have_content 'Sign in with Vkontakte'
    end

    context 'vkontakte provides email' do
      scenario 'user can sign in with vkontakte' do
        mock_auth_hash(:vkontakte)
        click_on 'Sign in with Vkontakte'
        expect(page).to have_content 'Successfully authenticated from Vkontakte account'
      end
    end

    context 'vkontakte does not provide email' do
      background do
        mock_auth_hash(:vkontakte)[:info][:email] = nil
        click_on 'Sign in with Vkontakte'
        clear_emails
      end

      scenario 'user can see form for enter his email' do
        expect(page).to have_content 'Please, enter your email'
      end

      scenario 'user can enter his email' do
        fill_in 'email', with: 'test@test.com'
        click_on 'Submit'
        expect(page).to have_content 'Confirmation email sent to your email. Please confirm before'
      end

      scenario 'user can takes confirmation email' do
        fill_in 'email', with: 'test@test.com'
        click_on 'Submit'

        open_email('test@test.com')
        expect(current_email).to have_content 'Confirm email'
      end

      scenario 'user can sign in after confirmation email' do
        fill_in 'email', with: 'test@test.com'
        click_on 'Submit'

        open_email('test@test.com')
        current_email.click_link 'Confirm'

        expect(page).to have_content 'Your email Successfully confirmed'
      end
    end
  end

  describe 'yandex oauth' do
    scenario 'user can be able to sign in with yandex' do
      expect(page).to have_content 'Sign in with Yandex'
    end

    context 'yandex provides email' do
      scenario 'user can sign in with yandex' do
        mock_auth_hash(:yandex)
        click_on 'Sign in with Yandex'
        expect(page).to have_content 'Successfully authenticated from Yandex account'
      end
    end

    context 'yandex does not provide email' do
      background do
        mock_auth_hash(:yandex)[:info][:email] = nil
        click_on 'Sign in with Yandex'
        clear_emails
      end

      scenario 'user can see form for enter his email' do
        expect(page).to have_content 'Please, enter your email'
      end

      scenario 'user can enter his email' do
        fill_in 'email', with: 'test@test.com'
        click_on 'Submit'
        expect(page).to have_content 'Confirmation email sent to your email. Please confirm before'
      end

      scenario 'user can takes confirmation email' do
        fill_in 'email', with: 'test@test.com'
        click_on 'Submit'

        open_email('test@test.com')
        expect(current_email).to have_content 'Confirm email'
      end

      scenario 'user can sign in after confirmation email' do
        fill_in 'email', with: 'test@test.com'
        click_on 'Submit'

        open_email('test@test.com')
        current_email.click_link 'Confirm'

        expect(page).to have_content 'Your email Successfully confirmed'
      end
    end
  end
end
