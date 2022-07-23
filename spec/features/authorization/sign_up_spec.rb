require 'rails_helper'

feature 'User can sign up', '
  In order to ask questions
  As an unauthenticated user
  User would like to be able to sign up
' do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: "a#{user.email}"
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign up with invalid params' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'prohibited this user from being saved'
  end
end
