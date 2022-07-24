require 'rails_helper'

feature 'User can sign in with github oauth2', '
  In order to ask questions
  As an unauthenticated user
  User would like to be able to sign in
  with his github account
' do
  background do
    visit new_user_session_path
  end

  describe 'github oauth' do
    scenario 'user can be able to sign in with github' do
      expect(page).to have_content 'Sign in with GitHub'
    end

    context 'github provides email' do
      background do
        mock_auth_hash(:github)
        click_on 'Sign in with GitHub'
      end

      scenario 'user sign in with GitHub' do
        expect(page).to have_content 'Successfully authenticated from Github account.'
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
  end

  describe 'provider does not provide email' do
    background do
      mock_auth_hash(:github)[:info][:email] = nil
      click_on 'Sign in with GitHub'
    end

    scenario 'user can see form for enter his email' do
      expect(page).to have_content 'Please, enter your email'
    end

    scenario 'user see form to send his email' do
      fill_in 'email', with: 'test@test.com'

      click_on 'Submit'

      expect(page).to have_content 'Check your email to confirm registration!'
    end

    scenario 'user can not enter invalid email' do
      fill_in 'email', with: nil
      click_on 'Submit'

      expect(page).to have_content 'Please, enter valid email'
    end

    scenario 'user can takes confirmation email' do
      fill_in 'email', with: 'test@test.com'
      click_on 'Submit'

      open_email('test@test.com')

      expect(current_email).to have_content 'Confirm my account'
    end

    scenario 'user can sign in after email confirmation' do
      fill_in 'email', with: 'test@test.com'
      click_on 'Submit'

      open_email('test@test.com')
      current_email.click_link 'Confirm'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end
end
