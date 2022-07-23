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

    scenario 'user can sign in with github' do
      mock_auth_hash(:github)
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from Github account'
    end
  end

  describe 'vkontakte oauth' do
    scenario 'user can be able to sign in with vkontakte' do
      expect(page).to have_content 'Sign in with Vkontakte'
    end

    scenario 'user can sign in with vkontakte' do
      mock_auth_hash(:vkontakte)
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'Successfully authenticated from Vkontakte account'
    end
  end

  describe 'yandex oauth' do
    scenario 'user can be able to sign in with yandex' do
      expect(page).to have_content 'Sign in with Yandex'
    end

    scenario 'user can sign in with yandex' do
      mock_auth_hash(:yandex)
      click_on 'Sign in with Yandex'
      expect(page).to have_content 'Successfully authenticated from Yandex account'
    end
  end
end
